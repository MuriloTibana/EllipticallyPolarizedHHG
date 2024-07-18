#!/bin/bash

REMOTE_USER="muti9295"
REMOTE_SERVER="terra.colorado.edu"
REMOTE_DIR="/data/becker/begh0305/Research/Hydrogen/cross_polarized/800nm_400nm/time_delay_scan"
LOCAL_DIR="results/"

# Find all files named 'dip_acc.txt' on the remote server
FILES=$(ssh "$REMOTE_USER@$REMOTE_SERVER" "find $REMOTE_DIR -type f -name 'dip_acc.txt'")

if [ -n "$FILES" ]; then
    # Iterate over each found file
    for FILE in $FILES; do
        # Extract the subdirectory path by removing the REMOTE_DIR prefix
        SUBDIR=$(ssh "$REMOTE_USER@$REMOTE_SERVER" "dirname ${FILE#$REMOTE_DIR/}")
        # Create the local subdirectory if it doesn't exist
        mkdir -p "$LOCAL_DIR/$SUBDIR"
        #
        echo "$SUBDIR"
        # Copy the file from the remote server to the local directory
        scp "$REMOTE_USER@$REMOTE_SERVER:$FILE" "$LOCAL_DIR/$SUBDIR/"
    done
else
    echo "No files found."
fi
