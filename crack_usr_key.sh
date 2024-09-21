#!/bin/bash

srcdir=$(dirname "$0")
echo "Source Directory: $srcdir"
rm -f $srcdir/*.aax
cp $1 $srcdir
cd $srcdir

file=$(ls *.aax)
echo "Getting checksum for file: $file"
checksum=$(ffprobe $file 2>&1 | grep checksum | awk -F 'checksum ==' '{print $2}')
echo "Checksum = $checksum"
echo "Attempting to crack file $file using rcrack"
activation_bytes=$(./rcrack . -h $checksum | grep 'hex:' | awk -F 'hex:' '{print $2}')
echo "Success!"
echo "User activation key: $activation_bytes"
