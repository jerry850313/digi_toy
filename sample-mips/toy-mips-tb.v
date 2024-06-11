`include "toy-mips.v"

module tb_toy_processor;

    // Clock and reset signals
    reg clk;
    reg reset;

    reg [31:0] instruction_word [0:63];

    // Instantiate the toy processor
    toy_processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initialize the simulation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Reset the processor
        #20;
        reset = 0;

        // Wait for halt instruction
        wait(uut.instruction == 32'h0000003f);
        #10;

        // Dump the data memory and register file in 8-by-8 4-byte style
        $display("\nData Memory:");
        for (integer i = 0; i < 64; i = i + 8) begin
            $display("%2d: %08h %08h %08h %08h %08h %08h %08h %08h", i,
                uut.data_memory[i], uut.data_memory[i + 1], 
                uut.data_memory[i + 2], uut.data_memory[i + 3],
                uut.data_memory[i + 4], uut.data_memory[i + 5], 
                uut.data_memory[i + 6], uut.data_memory[i + 7]);
        end

        $display("\nRegister File:");
        for (integer i = 0; i < 32; i = i + 8) begin
            $display("$%-2d: %08h %08h %08h %08h %08h %08h %08h %08h", i,
                uut.registers[i], uut.registers[i + 1], 
                uut.registers[i + 2], uut.registers[i + 3],
                uut.registers[i + 4], uut.registers[i + 5], 
                uut.registers[i + 6], uut.registers[i + 7]);
        end
        $display("\n");

        // Finish the simulation
        $finish;
    end

    initial begin
        // initial uut.data_memory[0:63] = 0
        for (integer i = 0; i < 64; i = i + 1) begin
            uut.data_memory[i] = 0;
        end
        // initial uut.registers[0:31] = 0
        for (integer i = 0; i < 32; i = i + 1) begin
            uut.registers[i] = 0;
        end

        // Read the 4-byte (32-bit) instructions from the hex file
        $readmemh("toy-mips.hex", instruction_word);

        // Store each byte of the 4-byte instruction in the byte unit memory
        for (integer i = 0; i < 64; i = i + 1) begin
            uut.instruction_memory[4*i]     = instruction_word[i][31:24];
            uut.instruction_memory[4*i + 1] = instruction_word[i][23:16];
            uut.instruction_memory[4*i + 2] = instruction_word[i][15:8];
            uut.instruction_memory[4*i + 3] = instruction_word[i][7:0];
        end        

        // monitor pc and instruction
        $monitor("%8t %2d %8h", $time, uut.pc, uut.instruction);       
    end

    // store waveforms
    initial begin
        $dumpfile("toy-mips.vcd");
        $dumpvars(0, tb_toy_processor);
    end

endmodule
