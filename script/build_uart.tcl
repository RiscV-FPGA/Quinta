set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files_uart]
file mkdir $outputdir
create_project project $outputdir -force

# Set Properties
set board DIGILENTINC.COM:ARTY-A7-100:PART0:1.1
set_property board_part $board     [current_project]
set_property target_language Verilog [current_project]
set_property simulator_language Verilog [current_project]

# Set the file that will be top module
set top_module [file join "$ROOT" src uart_top.sv]

# HDL files
add_files -norecurse [file join "$ROOT" src uart_top.sv]
add_files -norecurse [file join "$ROOT" src uart.sv]
add_files -norecurse [file join "$ROOT" src uart_vga.sv]
add_files -norecurse [file join "$ROOT" src uart_vga_ram.sv]
add_files -norecurse [file join "$ROOT" src clk_wiz_wrapper.sv]

add_files -norecurse [file join "$ROOT" src uart_vga_ram.mem]
add_files -norecurse [file join "$ROOT" src uart_vga_one.mem]
add_files -norecurse [file join "$ROOT" src uart_vga_zero.mem]


add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]

import_files -force
update_compile_order -fileset sources_1

source [ file normalize [ file join $ROOT script clk_wiz.tcl ] ]
#make_wrapper -inst_template [ get_files {clk_wiz.bd} ]
#add_files -files [file join "$ROOT" vivado_files acoustic_warfare.srcs sources_1 bd zynq_bd hdl zynq_bd_wrapper.vhd]
update_compile_order -fileset sources_1

## run impl
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

start_gui