`timescale 1ns/1ps
// Run each core independently. Define TEST_DEC to select decryption.
module tb_aes;
    reg clk = 0, rst_n = 0, start = 0;
    reg [127:0] block_in;
    wire busy, done;
    wire [127:0] block_out;
    always #10 clk = ~clk;
`ifdef TEST_DEC
    aes_dec dut (.*);
`else
    aes_enc dut (.*);
`endif
    task check_block(input [127:0] plain, input [127:0] cipher);
        reg [127:0] expected;
        integer cycles;
        begin
            @(negedge clk);
`ifdef TEST_DEC
            block_in = cipher;
            expected = plain;
`else
            block_in = plain;
            expected = cipher;
`endif
            if (busy !== 0) $fatal(1, "core not idle");
            start = 1;
            @(negedge clk);
            start = 0;
            cycles = 0;
            while (done !== 1 && cycles < 5000) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (done !== 1) $fatal(1, "timeout waiting for done");
            if (block_out !== expected) $fatal(1, "got %h expected %h", block_out, expected);
            @(negedge clk);
            if (done !== 0) $fatal(1, "done must pulse for one clock");
        end
    endtask
    initial begin
        repeat (3) @(negedge clk);
        rst_n = 1;
        check_block(128'h00112233445566778899aabbccddeeff, 128'h69c4e0d86a7b0430d8cdb78070b4c55a);
        check_block(128'h01000000000000000000000000000000, 128'he37cd363dd7c87a09aff0e3e60e09c82);
        $display("PASS: both AES blocks");
        $finish;
    end
endmodule
