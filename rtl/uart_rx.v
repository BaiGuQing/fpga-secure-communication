module uart_rx (
    input wire clk, rst_n, uart_rxd,
    output wire rx_valid,
    output wire [7:0] rx_data
);
    // TODO 2: synchronize RX, sample 8N1 at bit centers, pulse rx_valid.
    assign rx_valid = 1'b0;
    assign rx_data = 8'd0;
endmodule
