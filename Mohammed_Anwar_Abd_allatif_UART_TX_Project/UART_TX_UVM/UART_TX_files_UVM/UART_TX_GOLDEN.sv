module uart_tx_golden (uart_tx_if.GOLDEN R_if);
  

  reg [3:0] state_g = R_if.IDLE;
  reg [3:0] counter_g = 0;
  reg [7:0] data_reg_g;
  reg parity_bit_g;

  always @(posedge R_if.clk or negedge R_if.reset) begin
    if (!R_if.reset) begin
      state_g <= R_if.IDLE;
      R_if.TX_OUT_EXP <= 1'b1;
      R_if.Busy_exp <= 1'b0;
      counter_g <= 0;
    end else begin
      case (state_g)
        R_if.IDLE: begin
          R_if.TX_OUT_EXP <= 1'b1;
          R_if.Busy_exp <= 1'b0;
        counter_g <=0 ;
        if (R_if.DATA_VALID) begin
            data_reg_g <= R_if.P_DATA;
            parity_bit_g <= (R_if.PAR_TYP == 0 ) ? ~^R_if.P_DATA : ^R_if.P_DATA ; 
            state_g <= R_if.START;
            R_if.Busy_exp <= 1'b1;
        end
          end
        R_if.START: begin
         R_if.TX_OUT_EXP <= 1'b0;
         state_g <= R_if.DATA;
         counter_g <= 0 ;
        end

        R_if.DATA: begin
          R_if.TX_OUT_EXP <= data_reg_g[counter_g];
          counter_g <= counter_g + 1 ;
          if (counter_g == 7) begin
            state_g <= (R_if.PAR_EN) ? R_if.PARITY : R_if.STOP ; 
            end
        end

        R_if.PARITY: begin
          R_if.TX_OUT_EXP <= parity_bit_g ;
          state_g <= R_if.STOP;
        end

        R_if.STOP: begin
          R_if.TX_OUT_EXP <= 1'b1;
          state_g <= R_if.IDLE;
        end
      endcase
    end
  end

endmodule
