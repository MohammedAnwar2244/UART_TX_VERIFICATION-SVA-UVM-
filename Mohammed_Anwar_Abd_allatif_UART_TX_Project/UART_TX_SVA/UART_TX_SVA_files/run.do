vlib work

vlog -sv +cover +acc \
UART_TX_IF.sv \
UART_TX.sv \
UART_TX_GOLDEN.sv \
UART_TX_MON.sv \
UART_TX_SVA.sv \
UART_TX_TEST.sv \
UART_TX_TOP.sv \
UART_pkg.sv

vsim -voptargs=+acc work.UART_TX_TOP -classdebug -uvmcontrol=all -coverage

add wave /UART_TX_TOP/clk
add wave -hex /UART_TX_TOP/R_if/*


run -all

coverage save uart_tx.ucdb -onexit


vcover report uart_tx.ucdb -details -all -annotate -output coverage.txt

# quit -sim
