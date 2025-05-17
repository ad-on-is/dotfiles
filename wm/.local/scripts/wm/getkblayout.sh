#́́́́́́́́́́́́!/bin/bash

setxkbmap -query | grep -E 'layout:|variant:' | awk '{print $2}' | paste -d ' ' -s
