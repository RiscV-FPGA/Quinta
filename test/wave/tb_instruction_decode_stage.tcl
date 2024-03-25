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
	tb_instruction_decode_stage.clk -
    tb_instruction_decode_stage.cycle
	tb_instruction_decode_stage.rst -
    tb_instruction_decode_stage.pc - 
    tb_instruction_decode_stage.instruction -
    tb_instruction_decode_stage.control -
    tb_instruction_decode_stage.immediate_data -

}

# Iterate through the list of signals and add them
foreach signal $signals {
	addSignal $signal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full