set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files]
file mkdir $outputdir


open_project /home/joker/Projects/Quinta/vivado_files/project.xpr
update_compile_order -fileset sources_1

set_property top tb_instruction_decode_stage [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

start_gui

launch_simulation
