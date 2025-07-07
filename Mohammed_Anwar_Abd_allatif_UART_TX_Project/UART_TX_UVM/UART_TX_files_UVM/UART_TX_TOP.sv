module uart_top ();
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import pack_test::*;

    bit clk;

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Interface instance
    uart_tx_if R_if(clk);

    // DUT and GOLDEN models
    uart_tx DUT (R_if);
    uart_tx_golden GO (R_if);

    // Bind assertion module correctly
    bind uart_tx uart_tx_assertions ASSERTION (R_if);

    // UVM config & run
    initial begin
        uvm_config_db#(virtual uart_tx_if)::set(null, "uvm_test_top", "UART_LL", R_if);
        run_test("test");
    end

endmodule
