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
    tb_top.cycle -
    tb_top.top_inst.pc_fetch -
    tb_top.top_inst.instruction_fetch -

    tb_top.top_inst.instruction_decode_stage_inst.TB_ALU_AND -
    tb_top.top_inst.instruction_decode_stage_inst.TB_ALU_OR -
    tb_top.top_inst.instruction_decode_stage_inst.TB_ALU_XOR -
    tb_top.top_inst.instruction_decode_stage_inst.TB_ALU_ADD -
    tb_top.top_inst.instruction_decode_stage_inst.TB_ALU_SUB -
    tb_top.top_inst.instruction_decode_stage_inst.TB_R_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_I_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_S_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_B_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_U_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_J_TYPE -
    tb_top.top_inst.instruction_decode_stage_inst.TB_alu_src -
    tb_top.top_inst.instruction_decode_stage_inst.TB_mem_read -
    tb_top.top_inst.instruction_decode_stage_inst.TB_mem_write -
    tb_top.top_inst.instruction_decode_stage_inst.TB_mem_to_reg -
    tb_top.top_inst.instruction_decode_stage_inst.TB_is_branch -
    tb_top.top_inst.instruction_decode_stage_inst.TB_reg_write -
    tb_top.top_inst.instruction_decode_stage_inst.TB_write_back_id -

}

# Iterate through the list of signals and add them
foreach signal $signals {
    addSignal $signal
    gtkwave::/Edit/Data_Format/Decimal
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
