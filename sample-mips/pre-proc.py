import re
import sys

def replace_labels_with_addresses(assembly_code):
    lines = assembly_code.strip().split('\n')
    labels = {}
    address = 0x0
    instructions = []

    for line in lines:
        line = line.split('#')[0].strip()
        if not line:
            continue
        if line.endswith(':'):
            label = line[:-1]
            labels[label] = address*4
        else:
            instructions.append((address, line))
            address += 1

    result = []
    for address, line in instructions:
        for label in labels:
            line = re.sub(r'\b{}\b'.format(label), str(labels[label]), line)
        result.append(f' {line:20} // {address*4:02}')

    return result

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <assembly_code_file>")
        sys.exit(1)

    assembly_file = sys.argv[1]

    try:
        with open(assembly_file, 'r') as file:
            assembly_code = file.read()
    except FileNotFoundError:
        print(f"File not found: {assembly_file}")
        sys.exit(1)

    new_assembly_code = replace_labels_with_addresses(assembly_code)
    for asm in new_assembly_code:
        print(asm)

if __name__ == "__main__":
    main()
