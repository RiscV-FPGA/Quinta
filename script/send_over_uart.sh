#!/bin/bash

# Read the file line by line
while IFS= read -r line; do
    # Iterate over each character in the line
    for char in $(echo "$line" | sed 's/./& /g'); do
        # Access each character and process accordingly
        echo -n "\0$char" >/dev/ttyUSB0
        # Add your processing logic here
    done
done <src/instruction_mem_temp.mem
