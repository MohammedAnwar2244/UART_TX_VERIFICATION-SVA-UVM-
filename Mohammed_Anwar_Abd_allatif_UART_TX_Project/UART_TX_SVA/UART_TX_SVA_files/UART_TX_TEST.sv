import UART_TX_pkg::*;
module uart_tb (uart_tx_if.TEST u_if) ;

uart_tx_pkg uc = new () ;

int correct_counter = 0 ;
int error_counter = 0 ;

initial begin
  //UART_1
  assert_rst;
  //UART_2
  repeat(786) begin
  assert (uc.randomize())
  u_if.DATA_VALID = uc.DATA_VALID;
  u_if.P_DATA = uc.P_DATA ;
  u_if.PAR_EN = uc.PAR_EN ;
  u_if.PAR_TYP = uc.PAR_TYP ;
  @(posedge u_if.clk);
  u_if.DATA_VALID = 1'b0;
  repeat (9) begin
  @(posedge u_if.clk) ;
    uc.TX_OUT = u_if.TX_OUT ;
    uc.Busy = u_if.Busy ;
    @(posedge u_if.clk) ;
    check_result ;
  end
  end


  #2 $display ("NO. of Correct operations : 0d%0d , No. of errors : 0d%0d "
  ,correct_counter,error_counter);
  #2;
  $stop;
end

always @(posedge u_if.clk ) begin
  uc.uart_cg.sample();
end

task assert_rst ; 
    u_if.reset = 0 ;
    @(posedge u_if.clk);
    u_if.reset = 1 ;
endtask

task check_result ;
    if ((u_if.TX_OUT === u_if.TX_OUT_ex)&&(u_if.Busy === u_if.Busy_ex)) correct_counter ++ ;
    else begin
      $display ("Error at time 0t%0t " , $time );
      error_counter++ ;
    end
endtask

endmodule