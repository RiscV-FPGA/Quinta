stty -F /dev/ttyUSB1 115200
stty -F /dev/ttyUSB1 -crtscts

#stty -F /dev/ttyUSB0 crtscts    # To enable RTS/CTS flow control
#stty -F /dev/ttyUSB0 -crtscts   # To disable flow control with
#stty -a -F /dev/ttyUSB0         # To view the current settings for UART3, use

# Check if the file is provided as argument
if [ -z "$ZSH_VERSION" ]; then
    echo "Warning: This script must be run with Zsh. Exiting..."
    exit 1
fi

#stty -F /dev/ttyUSB0 crtscts    # To enable RTS/CTS flow control
#stty -F /dev/ttyUSB0 -crtscts   # To disable flow control with
#stty -a -F /dev/ttyUSB0         # To view the current settings for UART3, use

# Check if the file is provided as argument
filename=$1
if [ $# -ne 1 ]; then
    python3 src/mem_to_bytes.py
    filename='src/instruction_mem_temp.mem'
fi

# Read each line from the file and convert to hexadecimal
while IFS= read -r line; do

    line=$(echo "$line" | tr -d '\r\n\t\v\f')
    hex=$(echo "obase=16;ibase=2;$line" | bc)

    # Add leading zeros if necessary note: dont know if nessisary
    if [ ${#hex} -lt 2 ]; then
        hex="0$hex"
    fi

    echo "$hex"
    echo -n "\x$hex" >/dev/ttyUSB1
done <"$filename"

#echo -n "\xFF" > /dev/ttyUSB0
