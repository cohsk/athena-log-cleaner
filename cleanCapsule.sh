#!/bin/bash

# This script is designed to scrub a Cohesity time capsule using soscleaner
# Author:  Steve Klosky
# steve.klosky@cohesity.com
#
# Usage
# cleanCapsule.sh timecapsulepathandfilename
#
# Note - the script expect a .tar.gz formatted time capsule

echo "Starting Time Capsule Scrub"

# validate that the input file is a .tar.gz file (loose validation that it's a time capsule)
echo "Validating input file"
if [ "$1" = "" ] || [ "${1: -7}" != ".tar.gz" ]; then
    echo "Please enter a valid time capsule filename ending in .tar.gz"
    exit
fi

# setup an output directory
echo "Setting up output directory"
outDir="out-$(date)"
outDir="${outDir// /-}"
outDir="${outDir//:/-}"
mkdir "$outDir"

# setup a working directory
echo "Setting up working directory"
workDir="work-$(date)"
workDir="${workDir// /-}"
workDir="${workDir//:/-}"
mkdir "$workDir"

cwd=$(pwd)

# Unpack the .tar.gz file
echo "Unpacking the Time Capsule"
tar -zxvf "$1" -C "$workDir"

# some files and directories have IP addresses and or domain names in the filename and the directory name.
# Need to fix that before we start processing
find "$workDir" -type f > ./filelist.txt
find "$workDir" -type d > ./dirlist.txt
soscleaner -f ./filelist.txt ./dirlist.txt

# Unpack any .gz files which came from the Time Capsule Tarball
echo "Processing zipped files from the Time Capsule"
find "$workDir"/ -name "*.gz" -exec gunzip -k {} \;

# Loop through all directories and files and scrub them with soscleaner
# Skip scrubbing for .gz files
# Need to fish the final scrubbed file out of soscleaner's format
# Need to stash the obfuscation reports 
echo "Scrubbing Time Capsule files"
#find "$cwd"/"$workDir" -type f -exec soscleaner -f {} -o "$cwd"/"$outDir" \;
for myDirtyFile in `find "$cwd"/"$workDir" -type f`
do
   if [ "${myDirtyFile: -3}" != ".gz" ]; then
      soscleaner -f "$myDirtyFile" -o "$cwd"/"$outDir"
    fi
done

# uncompressing output files
find "$cwd"/"$outDir" -name "*.tar.gz" -exec tar -zxvf {} -C "$cwd"/"$outDir" \;

# the processed files are moved from the gz files to a subdirectory based on each cleaniing job
# need to scan cleaning job log files to find processed files
# then copy the processed file to a directory structure that matches 
# the inbound time capsule format

keyPhrase="adding additional file for analysis"
for myFile in `find "$cwd"/"$outDir" -name "soscleaner-*.log"`
do
  while IFS= read -r myLine
    do
      if [[ "$myLine" == *"$keyPhrase"* ]]; then
        # need to find the short filename and the short directory
        # and the soscleaner directory of the cleaned file
        # create the target directory
        # copy the cleaned file to the output directory
        outDirLen=${#outDir}
        cwdLen=${#cwd}
        myFileLen=${#myFile}
        sourceDirLen=$((myFileLen - 4 ))
        sourceDir=${myFile:0:sourceDirLen}
        targetDir=${myLine#*$keyPhrase}
        offset=$(( 5 + cwdLen + outDirLen ))
        targetDir=${targetDir:offset}
        offset=${targetDir##*/}
        offset=$((${#targetDir} - ${#offset}))
        targetDir=${targetDir:0:offset}
        targetDir="$outDir"/"$targetDir"
        mkdir -p "$targetDir"
        shopt -s dotglob
        echo "$sourceDir"
        cp "$sourceDir"/* "$targetDir"
      fi
    done < "$myFile"
done

# Repack the .gz files
echo "Zipping up scrubbed zip archives"
for myRepackFile in `find "$workDir"/ -name "*.gz"`
do
   workDirLen=${#workDir}
   outZip="$outDir"${myRepackFile:workDirLen}
   outZip="${outZip%.*}"
   gzip "$outZip"
done

# Repack the .tar.gz file
echo "Creating scrubbed Time Capsule Tarball"
cd "$outDir"
basename "$1"
tarball="$(basename -- $1)"
shorty=$(( ${#tarball} - 7))
tardir=${tarball:0:shorty}
tar -czvf "$tarball" "$tardir"
cd ..

# future option
# Pack up the obfuscation reports
# echo "Creating obfuscation reports tarball"