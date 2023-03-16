//均值滤波--1000个数
`timescale	1ns/1ps

module lms
(
	input							clk				,
	input							reset			,
	input		[15:0]				x_in			,
	input		[15:0]				d_in			,
	
	output		[15:0]				y_out			,
	output		[15:0]				e_out			,
);

	reg		[127:0]					coeff			;
	
	assign	e_out	=	d_in	-	y_out			;


//
integer	i	;
always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==1'b0)begin
		for(i	=	0;	i<RAM_DEPTH;	i=i+1)
			register[i]	<=0;
	end
	else if(wr_reg	==	1'b1)
		register[wr_cnt_r]<=data_in	;		
end

endmodule
























