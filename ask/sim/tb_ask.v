`timescale 100ns/1ps   //time scale = 0.1us
 
module tb_ask();
  reg CLK, START, X;
  
  //parameter initTime = 30;    //start after initTime 
  parameter period = 2;
  
  ask Obj(.clk(CLK), .rst(START), .x(X));
  
/*  period = 0.2us  */ 
  initial 
    begin 
      CLK = 0;
      //#initTime;
      forever
        #(period/2) CLK = ~CLK; 
    end
 
 
/*  ASK_CLK  */   
	initial 
    begin 
      START=0; 
	    @(posedge CLK);        
	    START=1;
    end	 
 
/* testbench */    
  initial 
      begin
        X=0;
        #50  X=1;  // 1 delay for 5us
        #50  X=0;  // 0 delay for 5us
        #50  X=1;  // 1 delay for 10us
        #100 X=0;  // 0 delay for 10us
        #100 X=1;  // 1 delay for 5us
        #50  X=0;  // 0 delay for 10us
        #100 X=1;  // 1 delay for 5us
        #50  X=0;   //0 delay forever
      end	
  
endmodule