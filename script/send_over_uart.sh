#!/bin/sh

# Read the file line by line
while IFS= read -r line; do
    # Initialize variables to hold each bit
    c0=""
    c1=""
    c2=""
    c3=""
    c4=""
    c5=""
    c6=""
    c7=""
    i=0

    # Iterate over each character in the line
    for char in $(echo "$line" | sed 's/./& /g'); do
        # Assign each character to the corresponding variable
        case $i in
        0) c0="$char" ;;
        1) c1="$char" ;;
        2) c2="$char" ;;
        3) c3="$char" ;;
        4) c4="$char" ;;
        5) c5="$char" ;;
        6) c6="$char" ;;
        7) c7="$char" ;;
        esac

        # Increment counter
        i=$((i + 1))
    done

    # Echo the next 8 bits together
    echo "$c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7"
    echo -n "\0$c0\0$c1\0$c2\0$c3\0$c4\0$c5\0$c6\0$c7" >/dev/ttyUSB0

done <src/instruction_mem_temp.mem
