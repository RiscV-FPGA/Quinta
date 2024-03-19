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
add_files [file join "$ROOT" src top.sv]
add_files [file join "$ROOT" src common_pkg.sv]
add_files [file join "$ROOT" src control.sv]
add_files [file join "$ROOT" src execute_stage.sv]
add_files [file join "$ROOT" src imm_gen.sv]
add_files [file join "$ROOT" src instruction_decode_stage.sv]
add_files [file join "$ROOT" src instruction_fetch_stage.sv]
add_files [file join "$ROOT" src memory_stage.sv]
add_files [file join "$ROOT" src writeback_stage.sv]

add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]

import_files -force
import_files -fileset sim_1 -norecurse [file join "$ROOT" test tb_top.sv]
import_files -fileset sim_1 -norecurse [file join "$ROOT" test tb_instruction_decode_stage.sv]


set_property top tb_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

## run impl
#launch_runs impl_1 -to_step write_bitstream -jobs 4
#wait_on_run impl_1

start_gui