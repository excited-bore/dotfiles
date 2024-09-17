# Most of them are from here
# https://wiki.archlinux.org/title/PipeWire#PipeWire_patch_sets_for_command_line

function pw-savewires(){
    if [[ "$#" -ne 1 ]]; then
            echo
            echo 'usage: pw-savewires filename'
            echo
            exit 0
    fi

    rm $1 &> /dev/null
    while IFS= read -r line; do
            link_on=`echo $line | cut -f 4 -d '"'`
            link_op=`echo $line | cut -f 6 -d '"'`
            link_in=`echo $line | cut -f 8 -d '"'`
            link_ip=`echo $line | cut -f 10 -d '"'`
            echo "Saving: " "'"$link_on:$link_op"','"$link_in:$link_ip"'"
            echo "'"$link_on:$link_op"','"$link_in:$link_ip"'" >> $1
    done < <(pw-cli dump short link)
}


function pw-dewire(){
    while read -r line; do
            echo 'Dewiring: ' $line '...'
            pw-link -d $line
    done < <(pw-cli dump short link {{!}} grep -Eo '^[0-9]+')
}

#!/bin/python

#import sys
#import csv
#import os
#
#def pw-dewire():
#    if len(sys.argv) < 2:
#            print('\n usage: pw-loadwires filename\n')
#            quit()
#
#    with open(sys.argv[1], newline='') as csvfile:
#            pwwreader = csv.reader(csvfile, delimiter=',', quotechar='"')
#            for row in pwwreader:
#                    print('Loading:  ' + row[0] + ' --> ' + row[1])
#                    process = os.popen('pw-link ' + row[0] + ' ' + row[1])
#
