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

# setup a report directory
echo "Setting up report directory"
repDir="rep-$(date)"
repDir="${outDir// /-}"
repDir="${outDir//:/-}"
mkdir "$repDir"

# Unpack the .tar.gz file
echo "Unpacking the Time Capsule"
tar -zxvf "$1" -C "$workDir"

# some files and directories have IP addresses in them.  Need to fix that
# before we start processing

# Unpack any .gz files which came from the Time Capsule Tarball
echo "Processing zipped files from the Time Capsule"
find "$workDir"/ -name "*.gz" -exec gunzip -k {} +

# Loop through all directories and files and scrub them with soscleaner
# Need to fish the final scrubbed file out of soscleaner's format
# Need to stash the obfuscation reports 
echo "Scrubbing Time Capsule files"
find /tmp/"$workDir" -type f | xargs -I {} soscleaner -f {} -o /tmp/"$outDir"

# uncompressing output files
find /tmp/"$outDir" -name "*.tar.gz" -exec tar -zxvf {} -C /tmp/"$outDir" \;

# need to scan log files to find processed files
keyPhrase="adding additional file for analysis"
mkdir /tmp/"$outDir"/timecap
for myFile in `find /tmp/"$outDir" -name "soscleaner-*.log"`
do
  myPath=`dirname "$myFile"`
  myShortFileName=`basename "$myFile"`
  mySOScleanername="${myShortFileName: -4}"
  while IFS= read -r myLine
    do
      if [[ "$myLine" == *"$keyPhrase"* ]]; then
        echo loggger - "$myLine"
        # need to find the short filename and the short directory
        # and the soscleaner directory of the cleaned file
        # create the target directory
        # copy the cleaned file to the output directory
        sourceDir=/tmp/"$outDir"/"$mySOScleanername"/*
        targetDir=/tmp/"$outDir"/timecap/"$shortOutDir"
        mkdir -p "$targetDir"
        cp "$sourceDir" "$targetDir"
      fi
    done < "$myFile"
done

# Repack the .gz files
echo "Zipping up scrubbed zip archives"

# Repack the .tar.gz file
echo "Creating scrubbed Time Capsule Tarball"

# Pack up the obfuscation reports
echo "Creating obfuscation reports tarball"

