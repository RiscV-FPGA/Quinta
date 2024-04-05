BOLD=$(tput bold)
UNDERLINE=$(tput smul)
RESET_UNDERLINE=$(tput rmul)
RESET=$(tput sgr0)

UNDERLINE_1=$UNDERLINE"$1"$RESET_UNDERLINE
UNDERLINE_tb_1=$UNDERLINE"tb_$1"$RESET_UNDERLINE

remove_vcd=false

# for flags
for arg in "$@"; do
    case $arg in
    --rm_vcd)
        remove_vcd=true
        ;;
    -h | --help)
        echo "Usage: gtkwave_sv verilog_module_name [--rm_vcd] [-h]"
        echo "--rm_vcd : Removes .vcd-file at the end."
        echo "-h  : Display this help message."
        ;;
    # Add more flags here if needed
    *)
        # Ignore unrecognized flags, mabe print warning and help here
        ;;
    esac
done

echo "$BOLD Running $UNDERLINE_1 and $UNDERLINE_tb_1 $RESET"
venv/bin/python src/mem_to_bytes.py

#        --sv--       ------libs----- ---src-- ------tb-----
iverilog -g2012 -o $1 -l src/lib/*.sv src/*.sv test/tb_$1.sv

if [ $? -eq 0 ]; then #check if compiled correct
    vvp $1
    rm $1
    rm src/instruction_mem_temp.mem

    gtkwave waveform.vcd --script=test/wave/tb_$1.tcl
    if [ "$remove_vcd" = true ]; then
        rm waveform.vcd
    fi

    echo "$BOLD Test Bench $1 Done! $RESET"
else
    echo "$BOLD $UNDERLINE ERROR: Fail in compile! $REST"
fi
