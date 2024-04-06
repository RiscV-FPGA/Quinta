#
# Acustic Warfare environment setup
#
# NOTE: some locate patterns might be a bit lazy.
#       this might need some attention.
echo '
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⣿⣿⠀⠀⣿⣿⡇⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⣿⣿⠀⠀⣿⣿⡇⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠀⠀⠛⠛⠀⠀⠛⠛⠃⠀⠘⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⣿⣿⣏⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⣶⣶⣶⣶⣶⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣶⣶⣶⣶⣶ \033[0m
\033[30m       ⠛⠛⠛⠛⠛⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠛⠛⠛⠛⠛ \033[0m
\033[30m       ⣤⣤⣤⣤⣤⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⣤⣤⣤⣤⣤ \033[0m
\033[30m       ⠛⠛⠛⠛⠛⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠛⠛⠛⠛⠛ \033[0m
\033[30m       ⣤⣤⣤⣤⣤⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⣤⣤⣤⣤⣤ \033[0m
\033[30m       ⠛⠛⠛⠛⠛⠀⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠛⠛⠛⠛⠛ \033[0m
\033[30m       ⣤⣤⣤⣤⣤⠀⣿⣿⣿⣿⣿⣿⣧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣿⣿⣿⣿⣿⣿⠀⣤⣤⣤⣤⣤ \033[0m
\033[30m       ⠿⠿⠿⠿⠿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠿⠿⠿⠿⠿ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⠀⠀⣤⣤⠀⠀⣤⣤⠀⠀⢠⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⣿⣿⠀⠀⣿⣿⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
\033[30m       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⣿⣿⠀⠀⣿⣿⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ \033[0m
'

#
# mlocate
#
# Check that mlocate is installed, as its required later.
# locate is used to allow for diffrences in install location
# between systems and are faster than find in the common case.
# NOTE: update db and check prune patterns if trouble shooting
if [ ! "$(command -v locate)" ]; then
    echo "\033[1;41mERROR: Please install 'mlocate'\033[0m"
    return 0
fi

#
# Python
#
# 'venv' setup and activation
VENV_NAME="venv"
# TODO: trigger on changes to requirements.txt to stay up to date.
# NOTE: to slow to always run
if [ ! -d "$VENV_NAME" ]; then
    echo -e "Python environment setup"
    python3 -m venv $VENV_NAME
    $VENV_NAME/bin/python -m pip install setuptools wheel
    $VENV_NAME/bin/python -m pip install -r requirements.txt
    $VENV_NAME/bin/python -m pip install vunit_hdl

fi
# TODO: Add explicit python min version and check
. $VENV_NAME/bin/activate
python3 --version

#
# Vivado
#
VIVADO_VERSION="2017.4"
XILINX_PATH="$ "/usr/local/Xilinx/Vivado/$VIVADO_VERSION""
#echo -e "$\033[1;33m $XILINX_PATH \033[0m" #print path
[ $? -eq 0 ] && . "/usr/local/Xilinx/Vivado/2017.4/settings64.sh" || echo -e "\033[1;33mWARNING: Could not locate Vivado $VIVADO_VERSION\033[0m"
echo "Vivado $VIVADO_VERSION"

# TODO: set up simlibs and path to them
# NOTE: xsim will be needed for ip simulations if needed as most are verilog based

# TODO: check IVerilog

#
# Useful aliases
#
#alias clean="git clean -xdie $VENV_NAME"
#alias vunit='python3 $(git rev-parse --show-toplevel)/run.py -v '
alias build='vivado -notrace -mode batch -source $(git rev-parse --show-toplevel)/script/build.tcl'
alias build_uart='vivado -notrace -mode batch -source $(git rev-parse --show-toplevel)/script/build_uart.tcl'

alias clean_vivado='sh script/clean_vivado_files.sh'
alias sim_vivado='sh script/sim_vivado.sh'
#alias gtkwave_vhdl='python3 $(git rev-parse --show-toplevel)/run.py --gtkwave-fmt vcd --gui'
alias gtkwave_sv='sh script/gtkwave_sv.sh'
alias sim_vga='sh script/vga_verilator.sh'
alias send_uart='sh script/send_over_uart.sh'


echo -e '
Welcome to RiscV Quinta project!
   To run a test in a waveform viewer write: gtkwave_sv verilog_module_name
   To create and launch the Vivado project write: build
'

echo "READY!"

#
# Cleanup
#
unset GHDL_PATH GHDL_REQUIRED_VERSION GHDL_VERSION XILINX_PATH VENV_NAME VIVADO_VERSION
#unset GTK_PATH
