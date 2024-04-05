def remove_comments(line):
    return line.split('//')[0].strip()


def remove_underscores(line):
    return line.replace('_', '')


def split_into_chunks(line, chunk_size):
    return [line[i:i+chunk_size] for i in range(0, len(line), chunk_size)]


def main():
    input_file = 'src/instruction_mem.mem'
    output_file = 'src/instruction_mem_temp.mem'

    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    lines = [remove_comments(line) for line in lines]
    lines = [remove_underscores(line) for line in lines]
    lines = [line.strip() for line in lines if line]  # remove empty lines

    with open(output_file, 'w') as outfile:
        for line in lines:
            if len(line) % 32 == 0:
                chunks = split_into_chunks(line, 8)
            else:
                chunks = [line[i:i+8] for i in range(0, len(line), 8)]
            for chunk in chunks:
                outfile.write(chunk + '\n')


if __name__ == "__main__":
    main()
