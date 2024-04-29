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
    TOP.sys_clk -
    TOP.rst -
    TOP.top.pc_fetch -


}

# Iterate through the list of signals and add them
foreach signal $signals {
    addSignal $signal
    gtkwave::/Edit/Data_Format/Decimal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
