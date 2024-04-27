verilator -Isrc src/lib/common_pkg.sv --cc src/top.sv --exe test/tb_top_vga.cpp -o top_vga -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
make -C ./obj_dir -f Vcommon_pkg.mk
./obj_dir/top_vga


#verilator --cc src/lib/*.sv --cc src/*.sv
#verilator --cc src/lib/*.sv --cc src/*.sv --exe test/tb_top_vga.cpp 
#verilator --cc --exe --build test/tb_top_vga.cpp --cc src/lib/*.sv --cc src/*.sv 

#verilator -Isrc/ --cc src/lib/*.sv --cc src/*.sv --exe test/tb_top_vga.cpp -o $1  -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)" 
#make -C ./obj_dir -f V$1.mk
#./obj_dir/$1
#rm obj_dir -r

##verilator --cc --exe --build test/tb_vga.cpp -o vga -Isrc/ --cc src/vga*.sv -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
##verilator -Isrc/ --cc src/vga.sv --exe test/tb_vga.cpp -o vga     -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
##verilator -Isrc/ --cc src/lib/common_pkg.sv --cc src/lib/common_instructions_pkg.sv --cc src/top.sv --exe test/tb_top_vga.cpp -o vga     -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
