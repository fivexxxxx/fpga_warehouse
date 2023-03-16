//异步FIFO
module asyn_fifo
#(
	parameter			DATA_WIDTH	=			16				,
	parameter			DATA_DEPTH	=			8				,
	parameter			RAM_DEPTH	=			256
)
(
	input							rst_n			,
	
	input							wr_clk			,
	input							wr_en			,	
	input	[DATA_WIDTH-1:0]		data_in			,
	output							full			,
	
	input							rd_clk			,
	input							rd_en			,	
	output	reg	[DATA_WIDTH-1:0]	data_out		,
	output							empty			
	
);
	

	wire		[DATA_DEPTH-1:0]		wr_adr			;
	wire		[DATA_DEPTH-1:0]		rd_adr			;
	//多一位用来判断空和满
	reg		[DATA_DEPTH:0]		wr_adr_ptr		;
	reg		[DATA_DEPTH:0]		rd_adr_ptr		;
	
	wire	[DATA_DEPTH:0]		wr_adr_gray		;
	reg		[DATA_DEPTH:0]		wr_adr_gray1		;
	reg		[DATA_DEPTH:0]		wr_adr_gray2		;
	wire	[DATA_DEPTH:0]		rd_adr_gray		;
	reg		[DATA_DEPTH:0]		rd_adr_gray1		;
	reg		[DATA_DEPTH:0]		rd_adr_gray2		;
	
///////////////////////////////////
assign	wr_adr	=	wr_adr_ptr[DATA_DEPTH-1:0]	;
assign	rd_adr	=	rd_adr_ptr[DATA_DEPTH-1:0]	;

////////////////////////////////////////////

integer					i							;
reg	[DATA_WIDTH-1:0]	ram_fifo[RAM_DEPTH-1:0]		;


always@(posedge	wr_clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		for(i	=	0;	i<RAM_DEPTH;	i=i+1)
			ram_fifo[i]	<='d0;
	end
	else if(wr_en &&(~full))
		ram_fifo[wr_adr]<=data_in	;	
	else
		ram_fifo[wr_adr]	<=	ram_fifo[wr_adr];
end

always@(posedge	rd_clk	or	negedge	rst_n)	begin
	if(!rst_n)
		data_out	<=	'd0;	
	else if(rd_en && (~empty))
		data_out	<=	ram_fifo[rd_adr]	;		
	else
		data_out	<=	'd0	;
end
/////////////////////////////////
always@(posedge	wr_clk	or	negedge	rst_n)	begin
	if(!rst_n)
		wr_adr_ptr	<='d0;
	else if(wr_en && (~full))
		wr_adr_ptr	<=	wr_adr_ptr+1'b1;
	else
		wr_adr_ptr<=wr_adr_ptr;
end 

always@(posedge	rd_clk	or	negedge	rst_n)	begin
	if(!rst_n)
		rd_adr_ptr	<='d0;
	else if(rd_en && (~empty))
		rd_adr_ptr	<=	rd_adr_ptr+1'b1;
	else
		rd_adr_ptr<=rd_adr_ptr;
end 
///binary to gray

assign	wr_adr_gray=(wr_adr_ptr>>1)^wr_adr_ptr;
assign	rd_adr_gray=(rd_adr_ptr>>1)^rd_adr_ptr;
//gray cdc compare

always@(posedge	wr_clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		rd_adr_gray1	<=	'd0	;
		rd_adr_gray2	<=	'd0	;
	end
	else begin
		rd_adr_gray1	<=	rd_adr_gray	;
		rd_adr_gray2	<=	rd_adr_gray1;
	end 
end

always@(posedge	rd_clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		wr_adr_gray1	<=	'd0	;
		wr_adr_gray2	<=	'd0	;
	end
	else begin
		wr_adr_gray1	<=	wr_adr_gray	;
		wr_adr_gray2	<=	wr_adr_gray1;
	end 
end

assign empty	=	(rd_adr_gray	==	wr_adr_gray2)?1'b1:1'b0;
assign full		=	(wr_adr_gray[DATA_DEPTH:DATA_DEPTH-1]!=rd_adr_gray2[DATA_DEPTH:DATA_DEPTH-1])&&(wr_adr_gray[DATA_DEPTH-2:0]==rd_adr_gray2[DATA_DEPTH-2:0]);



endmodule
























