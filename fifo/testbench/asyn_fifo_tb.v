`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/14 10:30:49
// Design Name: 
// Module Name: syn_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module asyn_fifo_tb;
    
    reg 						      rst_n;
								
	reg 						      wr_clk;
	reg 						      wr_en;
	reg 	      [15:0]	          data_in;
	wire						      full;
				
	reg 						      rd_clk;
	reg 						      rd_en;
	wire	      [15:0]	          data_out;
	wire	 					      empty;

    asyn_fifo asyn_fifo_inst
	(
		  .rst_n      (rst_n),
								
		  .wr_clk     (wr_clk),
		  .wr_en      (wr_en),
		  .data_in    (data_in),
		  .full       (full),
				
		  .rd_clk     (rd_clk),
		  .rd_en      (rd_en),
		  .data_out   (data_out),
		  .empty      (empty)
);
    
    initial wr_clk = 0;
    always#10 wr_clk = ~wr_clk;
    
    initial rd_clk = 0;
    always#30 rd_clk = ~rd_clk;
    
    always@(posedge wr_clk or negedge rst_n)begin
        if(!rst_n)
            data_in <= 'd0;
        else if(wr_en)
            data_in <= data_in + 1'b1;
        else
            data_in <= data_in;
    end
    
    initial begin
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        #200;
        rst_n = 1;
        wr_en = 1;
        #20000;
        wr_en = 0;
        rd_en = 1;
        #20000;
        rd_en = 0;
        $stop; 
    end
    
endmodule
