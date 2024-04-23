
verilator -Isrc/ --cc src/$1.sv --exe test/tb_vga.cpp -o $1     -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
make -C ./obj_dir -f V$1.mk
./obj_dir/$1
#rm obj_dir -r