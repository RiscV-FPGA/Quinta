set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files]
file mkdir $outputdir
create_project project $outputdir -force

# Set Properties
set board DIGILENTINC.COM:ARTY-A7-100:PART0:1.1
set_property board_part $board     [current_project]
set_property target_language Verilog [current_project]
set_property simulator_language Verilog [current_project]

# Set the file that will be top module
set top_module [file join "$ROOT" src top.sv]

# HDL files
add_files -norecurse [file join "$ROOT" src top_build.sv]
add_files -norecurse [file join "$ROOT" src lib common_pkg.sv]
add_files -norecurse [file join "$ROOT" src alu.sv]
add_files -norecurse [file join "$ROOT" src control.sv]
add_files -norecurse [file join "$ROOT" src data_memory.sv]
add_files -norecurse [file join "$ROOT" src decompressor.sv]
add_files -norecurse [file join "$ROOT" src execute_stage.sv]
add_files -norecurse [file join "$ROOT" src imm_gen.sv]
add_files -norecurse [file join "$ROOT" src instruction_decode_stage.sv]
add_files -norecurse [file join "$ROOT" src instruction_fetch_stage.sv]
add_files -norecurse [file join "$ROOT" src instruction_memory.sv]
add_files -norecurse [file join "$ROOT" src memory_stage.sv]
add_files -norecurse [file join "$ROOT" src registers.sv]
add_files -norecurse [file join "$ROOT" src writeback_stage.sv]
add_files -norecurse [file join "$ROOT" src forwarding_unit.sv]
add_files -norecurse [file join "$ROOT" src hazard_detection_unit.sv]
add_files -norecurse [file join "$ROOT" src vga.sv]
add_files -norecurse [file join "$ROOT" src vga_ram.sv]
add_files -norecurse [file join "$ROOT" src uart_collector.sv]
add_files -norecurse [file join "$ROOT" src uart.sv]
add_files -norecurse [file join "$ROOT" src dsp_mul.sv]
add_files -norecurse [file join "$ROOT" src dsp_div.sv]

add_files -norecurse [file join "$ROOT" src vga_one.mem]
add_files -norecurse [file join "$ROOT" src vga_zero.mem]

add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]

import_files -force
update_compile_order -fileset sources_1

start_gui

## run impl
launch_runs impl_1 -to_step write_bitstream
#wait_on_run impl_1
