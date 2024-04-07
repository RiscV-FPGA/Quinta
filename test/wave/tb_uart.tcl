set nfacts [gtkwave::getNumFacs]
puts "$nfacts"

# Function to add a signal and handle errors if it doesn't exist
proc addSignal {signal} {
    set result [catch {gtkwave::addSignalsFromList "$signal"} error_message]
    if {$result != 0} {
        puts "Error adding signal $signal: $error_message"
    }
}

# List of signals to add
set signals {
    tb_uart.clk -

    tb_uart.uart_inst.clk_counter -
    tb_uart.uart_inst.bit_index_counter -
    tb_uart.uart_inst.rx_serial -
    tb_uart.uart_inst.rx_serial_d -
    tb_uart.uart_inst.rx_serial_dd -
    tb_uart.uart_inst.rx_byte -
    tb_uart.uart_inst.rx_byte_valid -

}

# Iterate through the list of signals and add them
foreach signal $signals {
    addSignal $signal
    gtkwave::/Edit/Data_Format/Decimal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
