BOLD=$(tput bold)
UNDERLINE=$(tput smul)
RESET_UNDERLINE=$(tput rmul)
RESET=$(tput sgr0)

rm_txt=false

# for flags
for arg in "$@"; do
    case $arg in
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

# main
venv/bin/python AssembleRisc/src/main.py -i script/assembly.s
venv/bin/python script/mem_to_bytes.py
venv/bin/python script/send_over_uart.py

if [ "$rm_txt" = true ]; then
    rm script/instruction_mem_temp.txt
fi

echo "$BOLD Done! $RESET"
