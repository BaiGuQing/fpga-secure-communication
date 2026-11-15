set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE10F17C8
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name SDC_FILE board.sdc
set_location_assignment PIN_E1 -to clk
set_location_assignment PIN_M15 -to rst_n
set_location_assignment PIN_N6 -to uart_rxd
set_location_assignment PIN_N5 -to uart_txd
set_location_assignment PIN_L7 -to led_n
foreach port {clk rst_n uart_rxd uart_txd led_n} {
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to $port
}
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
