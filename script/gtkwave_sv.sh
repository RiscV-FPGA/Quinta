BOLD=$(tput bold)
UNDERLINE=$(tput smul)
RESET_UNDERLINE=$(tput rmul)
RESET=$(tput sgr0)

UNDERLINE_1=$UNDERLINE"$1"$RESET_UNDERLINE
UNDERLINE_tb_1=$UNDERLINE"tb-$1"$RESET_UNDERLINE

echo "$BOLD Running $UNDERLINE_1 and $UNDERLINE_tb_1 $RESET"

iverilog -g2012 -o $1 src/*.sv test/tb_$1.sv

if [ $? -eq 0 ]; then #check if compiled correct
    vvp $1
    rm $1
    gtkwave waveform.vcd --script=test/wave/tb_$1.tcl
    echo "$BOLD Test Bench $1 Done! $RESET"
else
    echo "$BOLD $UNDERLINE ERROR: Fail in compile! $REST"
fi