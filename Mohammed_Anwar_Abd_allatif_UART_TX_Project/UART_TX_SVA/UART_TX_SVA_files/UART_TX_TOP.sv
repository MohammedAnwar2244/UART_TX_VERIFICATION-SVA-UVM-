module UART_TX_TOP;
  bit clk;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  uart_tx_if R_if(clk);
  uart_tx dut(R_if);
  uart_tb tb(R_if);
  uart_golden_model golden(R_if);  
  bind uart_tx uart_tx_assertions T1(R_if);
endmodule
