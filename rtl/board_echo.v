// Independent pin/USB check. Repeats the serial waveform with two clocks of delay.
module board_echo (
    input wire clk, rst_n, uart_rxd,
    output wire uart_txd, led_n
);
    reg rx_meta, rx_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end else begin
            rx_meta <= uart_rxd;
            rx_sync <= rx_meta;
        end
    end
    assign uart_txd = rx_sync;
    assign led_n = rst_n;  // Hold reset to light D6.
endmodule
