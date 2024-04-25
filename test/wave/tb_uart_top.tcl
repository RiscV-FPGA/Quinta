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
    tb_uart_top.clk -
    tb_uart_top.rst -
    tb_uart_top.uart_collector_inst.rx_byte -
    tb_uart_top.uart_collector_inst.rx_byte_valid -
    tb_uart_top.uart_collector_inst.uart_collector_state -
    tb_uart_top.uart_collector_inst.byte_counter -
    tb_uart_top.uart_collector_inst.write_byte_address -
    tb_uart_top.uart_collector_inst.write_instr_data -
    tb_uart_top.uart_collector_inst.write_instr_valid -
    tb_uart_top.uart_collector_inst.start -
}

# Iterate through the list of signals and add them
foreach signal $signals {
    addSignal $signal
    gtkwave::/Edit/Data_Format/Decimal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
