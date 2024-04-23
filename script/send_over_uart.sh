#stty -F /dev/ttyUSB1 115200

#stty -F /dev/ttyUSB0 crtscts    # To enable RTS/CTS flow control
#stty -F /dev/ttyUSB0 -crtscts   # To disable flow control with
#stty -a -F /dev/ttyUSB0         # To view the current settings for UART3, use

# Check if the file is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

# Read each line from the file and convert to hexadecimal
while IFS= read -r line; do

    hex=$(echo "obase=16;ibase=2;$line" | bc)
    # Add leading zeros if necessary note: dont know if nessisary
    if [ ${#hex} -lt 2 ]; then
        hex="0$hex"
    fi

    #echo "$hex"
    echo -n "\x$hex" >/dev/ttyUSB1
done <"$filename"

#echo -n "\xFF" > /dev/ttyUSB0
