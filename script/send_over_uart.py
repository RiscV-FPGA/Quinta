import re
import serial

# Serial port configuration (replace with your actual values)
port = "/dev/ttyUSB1"
baudrate = 115200
filename = "script/instruction_mem_temp.txt"

# Open the serial port
try:
    ser = serial.Serial(port, baudrate)
except serial.SerialException as e:
    print(f"Error opening serial port: {e}")
    exit(1)

# Function to convert hex string to byte array, handling leading zeros


def hex_to_bytes(hex_str):
    # Remove leading zeros if present
    hex_str = hex_str.lstrip("0")
    # Ensure even number of hex digits
    if len(hex_str) % 2 != 0:
        hex_str = "0" + hex_str
    return bytearray.fromhex(hex_str)


def send_data(filename):
    # Read file line by line
    with open(filename, "r") as f:
        for line in f:
            # Clean line (remove whitespace and newline)
            clean_line = re.sub(r"\s+", "", line).strip()

            # Convert hex string to bytes (handling leading zeros)
            data_bytes = hex_to_bytes(clean_line)

            # Send data over UART
            try:
                ser.write(data_bytes)
            except serial.SerialException as e:
                print(f"Error sending data: {e}")


# Close the serial port
ser.close()
print("Data sent successfully.")
