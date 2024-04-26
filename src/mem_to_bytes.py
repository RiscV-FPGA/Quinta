# Define the input and output files
input_file = 'src/instruction_mem.mem'
output_raw_file = 'src/instruction_mem_raw.mem'
output_temp_file = 'src/instruction_mem_temp.mem'

# Open the input file and read line by line
with open(input_file, 'r') as infile:
    # Open the raw output file for writing
    with open(output_raw_file, 'w') as raw_outfile:
        # Open the temp output file for writing
        with open(output_temp_file, 'w') as temp_outfile:
            for line in infile:
                # Extract the binary content
                parts = line.split()
                binary_content = parts[-1] if len(parts) > 1 else ''
                
                # Check if there's a header, and if so, extract the 16-bit instruction
                if binary_content:
                    # Write the raw instruction to the raw output file
                    raw_outfile.write(binary_content + '\n')

                    # Pad with zeros to ensure that binary_instruction has a length that is a multiple of 8
                    binary_instruction_padded = binary_content.ljust(((len(binary_content) + 7) // 8) * 8, '0')
                    
                    # Split the binary instruction into 8-bit sections, and reverse the order
                    sections = [binary_instruction_padded[i:i+8] for i in range(0, len(binary_instruction_padded), 8)]
                    
                    # Write each section on a separate row in the temp output file
                    for section in sections[::-1]:
                        temp_outfile.write(section + '\n')

            # Add the last instruction containing 32 ones at the end of the temp output file
            last_instruction_32_ones = '1' * 32
            sections_last = [last_instruction_32_ones[i:i+8] for i in range(0, len(last_instruction_32_ones), 8)]
            for section in sections_last:
                temp_outfile.write(section + '\n')

        # Write the last instruction containing 32 ones to the raw output file
        raw_outfile.write(last_instruction_32_ones + '\n')
