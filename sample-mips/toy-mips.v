module toy_processor (
    input wire clk,
    input wire reset
);

    // Define registers and memory
    // 32 registers, 256 bytes of memory (instruction and data)
    reg [31:0] registers [0:31];
    reg [7:0] instruction_memory [0:255];
    reg [7:0] data_memory [0:255];

    // Program Counter
    reg [7:0] pc;

    // Instruction Fetch
    wire [31:0] instruction;
    assign instruction = {instruction_memory[pc], 
                          instruction_memory[pc + 1], 
                          instruction_memory[pc + 2], 
                          instruction_memory[pc + 3]};

    // Instruction Decode
    reg [5:0] opcode;
    reg [4:0] rs, rt, rd, shamt;
    reg [15:0] immediate;
    reg [25:0] label;
    reg [5:0] funct;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            opcode <= instruction[31:26];
            rs <= instruction[25:21];
            rt <= instruction[20:16];
            rd <= instruction[15:11];
            shamt <= instruction[10:6];
            immediate <= instruction[15:0];
            label <= instruction[25:0];
            funct <= instruction[5:0];

            // Execute instructions
            case (opcode)
                6'b001001: begin // li $rt, immediate
                    $display("li $%d, %d", rt, immediate);
                    registers[rt] <= {{16{immediate[15]}}, immediate};
                end
                6'b001000: begin // addi $rt, $rs, immediate
                    $display("addi $%d, $%d, %d", rt, rs, immediate);
                    registers[rt] <= registers[rs] + {{16{immediate[15]}}, immediate};
                end
                6'b100011: begin // lw $rt, offset($rs)
                    $display("lw $%d, %d($%d)", rt, immediate, rs);
                    registers[rt] <= {data_memory[registers[rs] + immediate + 3], 
                                      data_memory[registers[rs] + immediate + 2], 
                                      data_memory[registers[rs] + immediate + 1], 
                                      data_memory[registers[rs] + immediate]};
                end
                6'b101011: begin // sw $rt, offset($rs)
                    $display("sw $%d, %d($%d)", rt, immediate, rs);
                    data_memory[registers[rs] + immediate] <= registers[rt][7:0];
                    data_memory[registers[rs] + immediate + 1] <= registers[rt][15:8];
                    data_memory[registers[rs] + immediate + 2] <= registers[rt][23:16];
                    data_memory[registers[rs] + immediate + 3] <= registers[rt][31:24];
                end
                6'b000111: begin // bge $rs, $rt, label
                    $display("bge $%d, $%d, %d", rs, rt, label);
                    if (registers[rs] >= registers[rt]) begin
                        pc <= label[7:0];
                    end else begin
                        pc <= pc + 4;
                    end
                end
                6'b000110: begin // ble $rs, $rt, label
                    $display("ble $%d, $%d, %d", rs, rt, label);
                    if (registers[rs] <= registers[rt]) begin
                        pc <= label[7:0];
                    end else begin
                        pc <= pc + 4;
                    end
                end
                6'b000010: begin // j label
                    $display("j %d", label);
                    pc <= label[7:0];
                end
                6'b000000: begin
                    case (funct)
                        6'b100000: begin // add $rd, $rs, $rt
                            $display("add $%d, $%d, $%d", rd, rs, rt);
                            registers[rd] <= registers[rs] + registers[rt];
                        end
                        6'b100010: begin // sub $rd, $rs, $rt
                            $display("sub $%d, $%d, $%d", rd, rs, rt);
                            registers[rd] <= registers[rs] - registers[rt];
                        end
                        6'b000000: begin // sll $rd, $rt, shamt
                            $display("sll $%d, $%d, %d", rd, rt, shamt);
                            registers[rd] <= registers[rt] << shamt;
                        end
                        6'b000010: begin // srl $rd, $rt, shamt
                            $display("srl $%d, $%d, %d", rd, rt, shamt);
                            registers[rd] <= registers[rt] >> shamt;
                        end
                        6'b100001: begin // move $rd, $rs
                            $display("move $%d, $%d", rd, rs);
                            registers[rd] <= registers[rs];
                        end
                        6'b000000: begin // nop
                            // Do nothing
                        end
                        default: begin
                            $display("Unknown funct: %b", funct);
                        end
                    endcase
                end
                default: begin
                    if (opcode != 6'bxxxxxx)
                        $display("Unknown opcode: %b", opcode);
                end
            endcase

            // Increment PC if not branched or jumped
            if (opcode != 6'b000111 && opcode != 6'b000110 && opcode != 6'b000010) begin
                pc <= pc + 4;
            end
        end
    end

endmodule
