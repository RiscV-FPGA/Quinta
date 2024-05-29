BOLD=$(tput bold)
UNDERLINE=$(tput smul)
RESET_UNDERLINE=$(tput rmul)
RESET=$(tput sgr0)

rm_vcd=false
gtk_wave=false
rm_txt=false

# for flags
for arg in "$@"; do
    case $arg in
    --rm_vcd)
        rm_vcd=true
        ;;
    --gtk_wave)
        gtk_wave=true
        ;;
    --rm_txt)
        rm_txt=true
        ;;
    -h | --help)
        echo "Usage: sim_vga [--rm_vcd] [-h]"
        echo "--rm_vcd : Removes .vcd-file at the end."
        echo "-h  : Display this help message."
        ;;
    # Add more flags here if needed
    *)
        # Ignore unrecognized flags, mabe print warning and help here
        ;;
    esac
done

echo "$BOLD Running vga_top $RESET"

venv/bin/python AssembleRisc/src/main.py -i script/assembly.s
venv/bin/python script/mem_to_bytes.py

verilator --trace -Isrc src/lib/common_pkg.sv --cc src/top.sv
verilator --trace -Isrc src/lib/common_pkg.sv --cc src/top.sv --exe test/tb_top_vga.cpp -o top_vga -CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"
make -C ./obj_dir -f Vcommon_pkg.mk
./obj_dir/top_vga
#rm obj_dir -r

if [ "$gtk_wave" = true ]; then
    gtkwave waveform.vcd --script=test/wave/tb_top_vga.tcl
fi

if [ "$rm_vcd" = true ]; then
    rm waveform.vcd
fi

if [ "$rm_txt" = true ]; then
    rm script/instruction_mem_temp.txt
fi

echo "$BOLD Done! $RESET"
