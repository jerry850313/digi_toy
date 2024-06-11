`include "toy-mips.v"

module tb_toy_processor;

    reg clk;
    reg reset;
    
    toy_processor uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        #20;
        reset = 0;

        wait(uut.instruction == 32'h0000003f);
        #20;

        $display("\n-----------------");
        $display("Data Memory (HEX)");
        $display("-----------------");
        for (integer i = 0; i < 64; i = i + 8) begin
            $display("%-3d: %08h %08h %08h %08h %08h %08h %08h %08h", i,
                uut.data_mem[i], uut.data_mem[i + 1], 
                uut.data_mem[i + 2], uut.data_mem[i + 3],
                uut.data_mem[i + 4], uut.data_mem[i + 5], 
                uut.data_mem[i + 6], uut.data_mem[i + 7]);
        end

        $display("\n-------------------");
        $display("Register File (HEX)");
        $display("-------------------");
        for (integer i = 0; i < 32; i = i + 8) begin
            $display("$%-2d: %08h %08h %08h %08h %08h %08h %08h %08h", i,
                uut.rf[i], uut.rf[i + 1], 
                uut.rf[i + 2], uut.rf[i + 3],
                uut.rf[i + 4], uut.rf[i + 5], 
                uut.rf[i + 6], uut.rf[i + 7]);
        end

        $display("\n-----------------");
        $display("Data Memory (DEC)");
        $display("-----------------");
        for (integer i = 0; i < 64; i = i + 8) begin
            $display("%-3d: %8d %8d %8d %8d %8d %8d %8d %8d", i,
                uut.data_mem[i], uut.data_mem[i + 1], 
                uut.data_mem[i + 2], uut.data_mem[i + 3],
                uut.data_mem[i + 4], uut.data_mem[i + 5], 
                uut.data_mem[i + 6], uut.data_mem[i + 7]);
        end

        $display("\n-------------------");
        $display("Register File (DEC)");
        $display("-------------------");
        for (integer i = 0; i < 32; i = i + 8) begin
            $display("$%-2d: %8d %8d %8d %8d %8d %8d %8d %8d", i,
                uut.rf[i], uut.rf[i + 1], 
                uut.rf[i + 2], uut.rf[i + 3],
                uut.rf[i + 4], uut.rf[i + 5], 
                uut.rf[i + 6], uut.rf[i + 7]);
        end
        reset = 1;
        $display("");
        $finish;
    end

    initial begin
        $readmemh("data_mem.hex", uut.data_mem);
        $readmemh("inst_mem.hex", uut.inst_mem);
        $readmemh("rf.hex", uut.rf);
    end

    always @(posedge clk) begin
        if (reset==0)
            $write("%2d %8h    // ", uut.pc, uut.instruction);
    end

    initial begin
        $dumpfile("toy-mips.vcd");
        $dumpvars(0, tb_toy_processor);
    end

endmodule
