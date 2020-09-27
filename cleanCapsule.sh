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
    echo "Please enter a valid filename ending in .tar.gz"
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

# Unpack the .tar.gz file
echo "Unpacking the Time Capsule"
tar -zxvf "$1" -C "$workDir"

# Unpack any .gz files which came from the Time Capsule Tarball
echo "Processing zipped files from the Time Capsule"
find "$workDir"/ -name "*.gz" -exec gunzip -k {} +

# Loop through all directories and files and scrub them with soscleaner
# Need to fish the final scrubbed file out of soscleaner's format
# Need to stash the obfuscation reports 
echo "Scrubbing Time Capsule files"
find /tmp/"$workDir" -type f | xargs -I {} soscleaner -f {} -o /tmp/"$outDir"

#find /tmp/"$workDir" -type f -exec soscleaner -f {} \;
for myFile in `find /tmp/"$workDir" -type f`
do
  myPath=`dirname "$myFile"`
  myShortFileName=`basename "$myFile"`
  echo path $myPath
  echo file $myShortFileName
done

# Repack the .gz files
echo "Zipping up scrubbed zip archives"

# Repack the .tar.gz file
echo "Creating scrubbed Time Capsule Tarball"

# Pack up the obfuscation reports
echo "Creating obfuscation reports tarball"



look at This

# a="/apps/test/abc/file.txt"
# echo "${a%/*}/"
/apps/test/abc/