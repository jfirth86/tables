#!/bin/bash

folder=/run/user/1000/gvfs/smb-share:server=panda.local,share=photo/takeout-20231120T184037Z-019/Takeout

OIFS="$IFS"
IFS=$'\n'
i=0
for file in `find $folder -type f -name "*.jpg" -or -name "*.jpeg" -or -name "*.JPG"`  
do
    echo "File = $file"
    jpgMetaData=$(exiftool "$file")
    creationDate=$(echo "$jpgMetaData" | grep -oP "^Create Date\s+:\s(\d{4}:\d{2}:\d{2}\s\d{2}:\d{2}:\d{2})$" | grep -oP "\d{4}:\d{2}:\d{2}\s\d{2}:\d{2}:\d{2}$")
    if [ -z "$creationDate" ]
    then
        # Creation date not found. Look for another date type
        echo "Crete Date not found. Looking for another date tag"

    fi

    # Format date into the format expected for touch
    date=${creationDate/:/}
    date=${date/:/}
    date=${date/ /}
    date=${date/:/}
    date=${date/:/.}

    echo "New Date: $date"
    touch -t $date $file

    ((i++))
    #if [[ "$i" == '10' ]]
    #then
    #    echo "Number $i!"
    #    break
    #fi
done
IFS="$OIFS"

