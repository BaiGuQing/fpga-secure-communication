module top (
    input wire clk, rst_n, uart_rxd,
    output wire uart_txd, led_n
);
    wire rx_valid, tx_valid, tx_ready, led_on;
    wire [7:0] rx_data, tx_data;
    wire dec_start, dec_busy, dec_done, enc_start, enc_busy, enc_done;
    wire [127:0] dec_input, dec_output, enc_input, enc_output;

    assign led_n = ~led_on;

    uart_rx receiver (.clk(clk), .rst_n(rst_n), .uart_rxd(uart_rxd),
                      .rx_valid(rx_valid), .rx_data(rx_data));
    uart_tx sender (.clk(clk), .rst_n(rst_n), .tx_data(tx_data),
                    .tx_valid(tx_valid), .tx_ready(tx_ready), .uart_txd(uart_txd));
    comm_ctrl controller (
        .clk(clk), .rst_n(rst_n), .rx_valid(rx_valid), .rx_data(rx_data),
        .tx_valid(tx_valid), .tx_ready(tx_ready), .tx_data(tx_data), .led_on(led_on),
        .dec_start(dec_start), .dec_input(dec_input), .dec_busy(dec_busy),
        .dec_done(dec_done), .dec_output(dec_output),
        .enc_start(enc_start), .enc_input(enc_input), .enc_busy(enc_busy),
        .enc_done(enc_done), .enc_output(enc_output)
    );
    aes_dec decryptor (.clk(clk), .rst_n(rst_n), .start(dec_start), .block_in(dec_input),
                       .busy(dec_busy), .done(dec_done), .block_out(dec_output));
    aes_enc encryptor (.clk(clk), .rst_n(rst_n), .start(enc_start), .block_in(enc_input),
                       .busy(enc_busy), .done(enc_done), .block_out(enc_output));
endmodule
