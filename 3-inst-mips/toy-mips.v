module toy_processor (
    input wire clk,
    input wire reset
);

    // Define registers and memory
    // 32 registers, 256 bytes of memory (instruction and data)
    reg [31:0] rf [0:31];
    reg [31:0] inst_mem [0:63];
    reg [31:0] data_mem [0:63];

    // Program Counter
    reg [7:0] pc;

    // Instruction Fetch
    wire [31:0] instruction;
    assign instruction = inst_mem[pc];

    // Instruction Decode
    reg [5:0] opcode;
    reg [4:0] rs, rt, rd, shamt;
    reg [15:0] immediate;
    reg [25:0] address;
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
            address <= instruction[25:0];
            funct <= instruction[5:0];

            // Increment PC by default, override for branches/jumps
            pc <= pc + 1;

            // Execute instructions
            case (opcode)
                6'b001001: begin // li $rt, immediate
                    rf[rt] <= {{16{immediate[15]}}, immediate};
                    $display("li $%-2d, %-d", rt, immediate);
                end
                6'b001000: begin // addi $rt, $rs, immediate
                    rf[rt] <= rf[rs] + immediate;
                    $display("addi $%-2d, $%-2d, %-d", rt, rs, immediate);
                end
                6'b100011: begin // lw $rt, offset($rs)
                    rf[rt] <= data_mem[rf[rs] + immediate];
                    $display("lw $%-2d, %-d($%-2d)", rt, immediate, rs);
                end
                6'b101011: begin // sw $rt, offset($rs)
                    data_mem[rf[rs] + immediate] <= rf[rt];
                    $display("sw $%-2d, %-d($%-2d)", rt, immediate, rs);
                end
                6'b000000: begin
                    case (funct)
                        6'b000000: begin // sll  $rd, $rt, shamt
                            rf[rd] <= rf[rt] << shamt;
                            $display("sll $%-2d, $%-2d, $%-d", rd, rt, shamt);
                        end
                        6'b000010: begin // srl  $rd, $rt, shamt
                            rf[rd] <= rf[rt] >> shamt;
                            $display("srl $%-2d, $%-2d, $%-d", rd, rt, shamt);
                        end
                        6'b100000: begin // add $rd, $rs, $rt
                            rf[rd] <= rf[rs] + rf[rt];
                            $display("add $%-2d, $%-2d, $%-2d", rd, rs, rt);
                        end
                        6'b100010: begin // sub $rd, $rs, $rt
                            rf[rd] <= rf[rs] - rf[rt];
                            $display("sub $%-2d, $%-2d, $%-2d", rd, rs, rt);
                        end
                        6'b100001: begin // move $rd, $rs
                            rf[rd] <= rf[rs];
                            $display("move $%-2d, $%-2d", rd, rs);
                        end
                        6'b111111: begin // halt
                            $display("halt");
                        end
                        6'b001111: begin // nop
                            $display("nop");
                        end
                        default: begin
                            $display("Unknown funct: %b", funct);
                        end
                    endcase
                end
                6'b000111: begin // bge $rs, $rt, label
                    if (rf[rs] >= rf[rt]) begin
                        pc <= immediate;
                        $display("bge $%-2d, $%-2d, label", rs, rt);
                    end
                end
                6'b000110: begin // ble $rs, $rt, label
                    if (rf[rs] <= rf[rt]) begin
                        pc <= immediate;
                        $display("ble $%-2d, $%-2d, label", rs, rt);
                    end
                end
                6'b000010: begin // j label
                    pc <= address[7:0];
                    $display("j label %-d", address);
                end
                default: begin
                    $display("Unknown opcode: %b", opcode);
                end
            endcase
        end
    end

endmodule

