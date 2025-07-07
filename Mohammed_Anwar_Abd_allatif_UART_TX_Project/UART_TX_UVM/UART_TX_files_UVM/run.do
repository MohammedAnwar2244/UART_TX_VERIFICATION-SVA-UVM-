vlog -sv +cover +acc \
UART_TX_IF.sv \
UART_TX.sv \
UART_TX_GOLDEN.sv \
UART_TX_SVA.sv \
UART_TX_SEQ_ITEM_pkg.sv \
UART_TX_SEQS_pkg.sv \
UART_TX_COVERAGE_pkg.sv \
UART_TX_DRIVER_pkg.sv \
UART_TX_MONITOR_pkg.sv \
UART_TX_SCOREBOARD_pkg.sv \
UART_TX_SEQUENCER_pkg.sv \
UART_TX_AGENT_pkg.sv \
UART_TX_GONFIGRATION_pkg.sv \
UART_TX_ENVIRONMENT_pkg.sv \
UART_TX_TEST_pkg.sv \
UART_TX_TOP.sv \
+define+UVM_NO_DPI

vsim -voptargs=+acc work.uart_top -classdebug -uvmcontrol=all -coverage

add wave /uart_top/clk
add wave /uart_top/R_if/*

coverage save uart_tx.ucdb -onexit
run -all

vcover report uart_tx.ucdb -details -all -annotate -output coverage.txt
