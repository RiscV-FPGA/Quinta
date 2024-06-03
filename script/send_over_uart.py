import serial

# Serial port configuration (replace with your actual values)
port = "/dev/ttyUSB1"
baudrate = 115200
filename = "script/instruction_mem_temp.txt"

def bin_to_bytes(bin_str):
    # Convert binary string to integer
    num = int(bin_str, 2)
    # Convert integer to byte array (single byte)
    return num.to_bytes(1, 'big')

def send_data(filename):
    try:
        # Open the serial port using a context manager
        with serial.Serial(port, baudrate) as ser, open(filename, "r") as f:
            for line in f:
                # Clean line (remove whitespace and newline)
                clean_line = line.strip()
                if clean_line:  # Ensure the line is not empty
                    # Convert binary string to bytes
                    data_bytes = bin_to_bytes(clean_line)
                    # Send data over UART
                    ser.write(data_bytes)
                    print(f"Sent {data_bytes}")
        print("Data sent successfully.")
    except serial.SerialException as e:
        print(f"Error opening or communicating over serial port: {e}")
    except FileNotFoundError:
        print(f"File not found: {filename}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

send_data(filename)
