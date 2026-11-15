module aes_dec (
    input wire clk, rst_n, start,
    input wire [127:0] block_in,
    output wire busy, done,
    output wire [127:0] block_out
);
    `include "aes_tables.vh"
    // TODO 5: latch one input on start and iterate ten AES rounds.
    // Tables below the include are local functions; round 0 is the original key.
    assign busy = 1'b0;
    assign done = 1'b0;
    assign block_out = 128'd0;
endmodule
