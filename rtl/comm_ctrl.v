module comm_ctrl (
    input wire clk, rst_n, rx_valid, tx_ready,
    input wire [7:0] rx_data,
    output wire tx_valid, led_on,
    output wire [7:0] tx_data,
    output wire dec_start, enc_start,
    output wire [127:0] dec_input, enc_input,
    input wire dec_busy, dec_done, enc_busy, enc_done,
    input wire [127:0] dec_output, enc_output
);
    // TODO 3: receive 16 bytes, decrypt, apply command, encrypt reply, send 16 bytes.
    assign dec_start = 1'b0;
    assign enc_start = 1'b0;
    assign dec_input = 128'd0;
    assign enc_input = 128'd0;
    assign tx_valid = 1'b0;
    assign tx_data = 8'd0;
    assign led_on = 1'b0;
endmodule
