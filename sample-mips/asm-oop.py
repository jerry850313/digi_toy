import sys

class Assembler:
    def __init__(self):
        self.instructions = {
            'li': self._li_addi,
            'addi': self._li_addi,
            'lw': self._load_store,
            'sw': self._load_store,
            'add': self._r_type,
            'sub': self._r_type,
            'move': self._r_type,
            'sll': self._shift,
            'srl': self._shift,
            'bge': self._branch,
            'ble': self._branch,
            'j': self._jump,
            'nop': self._nop,
            'halt': self._halt,
        }

    def assemble(self, instruction, sep=''):
        parts = instruction.split()
        opcode = parts[0]
        operands = parts[1:]

        if opcode in self.instructions:
            return self.instructions[opcode](opcode, operands, sep)
        else:
            return None

    @staticmethod
    def reg_to_bin(reg):
        reg = reg.replace('$', '').replace('(', '').replace(')', '').replace(',', '')
        return format(int(reg), '05b') if reg.isdigit() else '00000'

    def _li_addi(self, opcode, operands, sep):
        rt = self.reg_to_bin(operands[0])
        rs = '00000' if opcode == 'li' else self.reg_to_bin(operands[1])
        immediate = int(operands[1]) if opcode == 'li' else int(operands[2])
        immediate_bin = format(immediate if immediate >= 0 else (1 << 16) + immediate, '016b')
        opcode_bin = '001001' if opcode == 'li' else '001000'
        return sep.join([opcode_bin, rs, rt, immediate_bin])

    def _load_store(self, opcode, operands, sep):
        rt = self.reg_to_bin(operands[0])
        offset, rs = operands[1].split('(')
        rs = self.reg_to_bin(rs)
        offset = int(offset)
        offset_bin = format(offset if offset >= 0 else (1 << 16) + offset, '016b')
        opcode_bin = '100011' if opcode == 'lw' else '101011'
        return sep.join([opcode_bin, rs, rt, offset_bin])

    def _r_type(self, opcode, operands, sep):
        rd = self.reg_to_bin(operands[0])
        rs = self.reg_to_bin(operands[1])
        rt = self.reg_to_bin(operands[2]) if opcode in ['add', 'sub'] else '00000'
        funct = '100000' if opcode == 'add' else '100010' if opcode == 'sub' else '100001'
        return sep.join(['000000', rs, rt, rd, '00000', funct])

    def _shift(self, opcode, operands, sep):
        rd = self.reg_to_bin(operands[0])
        rt = self.reg_to_bin(operands[1])
        shamt = format(int(operands[2]), '05b')
        funct = '000000' if opcode == 'sll' else '000010'
        return sep.join(['000000', '00000', rt, rd, shamt, funct])

    def _branch(self, opcode, operands, sep):
        rs = self.reg_to_bin(operands[0])
        rt = self.reg_to_bin(operands[1])
        label = format(int(operands[2]), '016b')
        opcode_bin = '000111' if opcode == 'bge' else '000110'
        return sep.join([opcode_bin, rs, rt, label])

    def _jump(self, opcode, operands, sep):
        address = format(int(operands[0]), '026b')
        return sep.join(['000010', address])

    def _nop(self, opcode, operands, sep):
        return '00000000000000000000000000000000'

    def _halt(self, opcode, operands, sep):
        return '00000000000000000000000000111111'

    @staticmethod
    def parse_assembly_file(file_path):
        with open(file_path, 'r') as f:
            instructions = f.readlines()
        instructions = [i.split('#')[0] for i in instructions]
        instructions = map(str.strip, instructions)
        instructions = list(filter(None, instructions))
        mc = []
        assembler = Assembler()
        for inst in instructions:
            inst = inst.strip()
            if inst:
                mc.append([assembler.assemble(inst), assembler.assemble(inst, ' '), inst])
        return mc

    @staticmethod
    def bin2hex(bin_str):
        try:
            return format(int(bin_str, 2), '08x')
        except ValueError:
            return '00000000'

if __name__ == '__main__':

    mc = Assembler.parse_assembly_file(sys.argv[1])

    with open('toy-mips.hex', 'w') as f:
        for i in mc:
            f.write(f"{Assembler.bin2hex(i[0])}   // {i[2]:15} # {i[1]} \n")
        f.write(f"00000000   // {'nop':15}\n")
        f.write(f"0000003f   // {'halt':15}\n")
        for _ in range(64-len(mc)-2):
            f.write(f"00000000   // {'nop':15}\n")
