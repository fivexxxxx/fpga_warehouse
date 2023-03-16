//同步FIFO
module fifo_syn
#(
	parameter			DATA_WIDTH	=			8				,
	parameter			DATA_DEPTH	=			8				,
	parameter			RAM_DEPTH	=			(1<<DATA_DEPTH)
)
(
	input							clk				,
	input							rst_n			,
	input	[DATA_WIDTH-1:0]		data_in			,
	input							wr_reg			,
	input							rd_reg			,
	
	output	reg	[DATA_WIDTH-1:0]	data_out		,
	output							empty			,
	output							full			
);
	

	reg		[DATA_DEPTH-1:0]		wr_cnt			;
	reg		[DATA_DEPTH-1:0]		rd_cnt			;
	reg		[DATA_DEPTH-1:0]		data_cnt		;
	
///////////////////////////////////
assign	full	=	(data_cnt	==	(RAM_DEPTH-1))?1'b1:1'b0	;

assign	empty	=	(data_cnt	==	0)?1'b1:1'b0	;
////////////////////////////////////////////
always@(posedge	clk	or	negedge	rst_n)	begin

	if(rst_n	==1'b0)begin
		wr_cnt	<=	0;
	end
	else if(wr_cnt	==	RAM_DEPTH-1)
		wr_cnt	<=	0;
	else if(wr_reg)begin
		wr_cnt	<=	wr_cnt	+	1'b1;
	end 
	else
		wr_cnt	<=	wr_cnt;	
end

////////////////////////////////////////////////
always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==1'b0)begin
		rd_cnt	<=	0;
	end
	else if(rd_cnt	==	RAM_DEPTH-1)
		rd_cnt	<=	0;
	else if(wr_reg)begin
		rd_cnt	<=	rd_cnt	+	1'b1;
	end 
	else
		rd_cnt	<=	rd_cnt;		
end

////////////////////////////////////////////////
always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==1'b0)begin
		data_cnt	<=	0;
	end
	else if(rd_reg	&&	!wr_reg	&&(data_cnt	!=0))begin
		data_cnt	<=	data_cnt-1;
	end 
	else if(wr_reg	&&	!rd_reg	&&(data_cnt != RAM_DEPTH-1))
		data_cnt	<=	data_cnt	+	1'b1;	 
	else
		data_cnt	<=	data_cnt;		
end

integer					i							;
reg	[DATA_WIDTH-1:0]	register[RAM_DEPTH-1:0]		;

always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==1'b0)begin
		for(i	=	0;	i<RAM_DEPTH;	i=i+1)
			register[i]	<=0;
	end
	else if(wr_reg	==	1'b1)
		register[wr_cnt]<=data_in	;		
end

always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==1'b0)begin
		data_out	<=	0;
	end
	else if(rd_reg	==	1'b1)
		data_out	<=	register[rd_cnt]	;		
	else
		data_out	<=	data_out	;
end

endmodule
























