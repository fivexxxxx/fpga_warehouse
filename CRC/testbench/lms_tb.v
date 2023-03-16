`timescale 1ns / 1ns

module mean_filter_tb;
    
    reg 						      clk		;
	reg 						      rst_n		;	
	reg 	      [23:0]	          data_in	;
	wire	      [23:0]	          data_out	;

    mean_filter
		#(.N(60))
	mean_filter_inst
	(
		.clk		(clk)		,
		.rst_n      (rst_n)		,		
		.data_in    (data_in)	,
		.data_out   (data_out)
);
    
    initial clk = 0;
    always#10 clk = ~clk;
    
    initial	begin
		rst_n	=1'b0;
		#200;
		rst_n	=1'b1;
	end 
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            data_in <= 'd0;
        else if(data_in	==	'd100)
            data_in <= 'd0;
        else
            data_in <= data_in+'b1;
    end
    
    
endmodule
