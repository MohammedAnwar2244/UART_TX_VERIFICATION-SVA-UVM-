interface uart_tx_if(clk);

// parameter Declaration	
parameter IDLE = 0;
parameter START = 1;
parameter DATA = 2;
parameter PARITY = 3;
parameter STOP = 4;

//----------------- input declaration ----------------
input bit clk;
logic reset ;
logic PAR_EN;
logic PAR_TYP;
logic  DATA_VALID;
logic [7:0] P_DATA;
//----------------- output declaration ---------------
logic TX_OUT , TX_OUT_EXP;
logic Busy , Busy_exp ;

//______________________________ MODPORTS ____________________________________//

modport DUT (input clk , reset , PAR_EN , PAR_TYP , DATA_VALID , P_DATA ,output TX_OUT , Busy );

modport GOLDEN (input clk , reset , PAR_EN , PAR_TYP , DATA_VALID , P_DATA ,output TX_OUT_EXP , Busy_exp );




    
endinterface 