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
	tb_top.clk -
	tb_top.rst -

}

# Iterate through the list of signals and add them
foreach signal $signals {
	addSignal $signal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full