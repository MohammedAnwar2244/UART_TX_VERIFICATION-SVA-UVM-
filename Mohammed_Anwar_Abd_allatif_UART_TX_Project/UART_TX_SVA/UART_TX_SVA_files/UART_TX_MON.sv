module uart_monitor (uart_tx_if.MONITOR u_if) ;
  always @(posedge u_if.clk ) begin
    $display("STIMULUS : Reset = 0b%0b , P_DATA = 0h%0h , PAR_EN = 0b%0b , PAR_TYP = 0b%0b ,
    DATA_VALID = 0b%0b " , u_if.reset , u_if.P_DATA , u_if.PAR_EN , u_if.PAR_TYP ,
    u_if.DATA_VALID);
    $display("OUTPUT : TX_OUT = 0b%0b , TX_OUT_ex = 0b%0b ,
              Busy = 0b%0b , Busy_ex = 0b%0b " , 
              u_if.TX_OUT,u_if.TX_OUT_ex,u_if.Busy,u_if.Busy_ex);
  end
endmodule