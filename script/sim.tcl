set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files]
file mkdir $outputdir


open_project /home/joker/Projects/Quinta/vivado_files/project.xpr
update_compile_order -fileset sources_1
add_files -norecurse -copy_to -force [file join "$ROOT" src top.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src lib common_instructions_pkg.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src lib common_pkg.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src alu.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src control.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src data_memory.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src decompressor.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src execute_stage.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src imm_gen.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src instruction_decode_stage.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src instruction_fetch_stage.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src instruction_memory.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src memory_stage.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src registers.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src writeback_stage.sv]
add_files -norecurse -copy_to -force [file join "$ROOT" src instruction_mem.mem]

import_files -fileset sim_1 -norecurse [file join "$ROOT" test tb_top.sv]
update_compile_order -fileset sources_1

set top_module [file join "$ROOT" src top.sv]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

start_gui

launch_simulation
