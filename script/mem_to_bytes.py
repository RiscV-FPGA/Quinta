# Define the input and output files
input_file = 'AssembleRisc/output/out_binary.txt'
output_temp_file = 'script/instruction_mem_temp.txt'

# Open the input file and read line by line
with open(input_file, 'r') as infile:
    with open(output_temp_file, 'w') as temp_outfile:
        for line in infile:
            binary_content = line.rstrip()
            # Check if there's a header, and if so, extract the 16-bit instruction
            if binary_content:
                # Pad with zeros to ensure that binary_instruction has a length that is a multiple of 8
                binary_instruction_padded = binary_content.ljust(
                    ((len(binary_content) + 7) // 8) * 8, '0')

                # Split the binary instruction into 8-bit sections, and reverse the order
                sections = [binary_instruction_padded[i:i+8]
                            for i in range(0, len(binary_instruction_padded), 8)]

                # Write each section on a separate row in the temp output file
                for section in sections[::-1]:
                    temp_outfile.write(section + '\n')

        # Add the last instruction one nop and one 32-ones at the end of the temp output file
        last_instruction_nop = '00010011000000000000000000000000'
        sections_last = [last_instruction_nop[i:i+8]
                         for i in range(0, len(last_instruction_nop), 8)]
        for section in sections_last:
            temp_outfile.write(section + '\n')

        last_instruction_32_ones = '1' * 32
        sections_last = [last_instruction_32_ones[i:i+8]
                         for i in range(0, len(last_instruction_32_ones), 8)]
        for section in sections_last:
            temp_outfile.write(section + '\n')
