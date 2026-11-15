module uart_tx (
    input wire clk, rst_n, tx_valid,
    input wire [7:0] tx_data,
    output wire tx_ready, uart_txd
);
    // TODO 2: accept a byte on valid && ready, send LSB first.
    assign tx_ready = 1'b0;
    assign uart_txd = 1'b1;
endmodule
