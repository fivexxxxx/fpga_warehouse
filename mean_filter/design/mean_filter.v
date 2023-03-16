//均值滤波--1000个数

module mean_filter
#(
	parameter			N			=			10				,
	parameter			DATA_WIDTH	=			24				,
	parameter			DATA_DEPTH	=			N				,
	parameter			RAM_DEPTH	=			N
)(
	input							clk				,
	input							rst_n			,
	input		[DATA_WIDTH-1:0]	data_in			,
	output	reg	[DATA_WIDTH-1:0]	data_out		
);

	reg	[31:0]			cnt			;
	wire				wr_reg		;
	reg					rd_reg		;
	
	reg		[DATA_DEPTH-1:0]		wr_cnt						;
	reg		[DATA_DEPTH-1:0]		wr_cnt_r					;
	reg		[DATA_DEPTH-1:0]		rd_cnt						;
	
	reg		[33:0]					data_all					;
	reg		[23:0]					data_aver					;
	
	reg		[DATA_WIDTH-1:0]		register[RAM_DEPTH-1:0]		;

//控制寄存器组的读写操作
always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		cnt	<=	'd0;
	end
	else if(cnt	==	N)
		cnt	<=	cnt;	
	else
		cnt	<=	cnt	+1'b1	;
end
assign	wr_reg	=1'b1	;

always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		rd_reg	<=	'b0;
	end
	else if(cnt	==	N-1)
		rd_reg	<=	1'b1;
	else
		rd_reg	<=	rd_reg	;
end
/// 累加和求平均值
always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		data_all	<=	'd0;
	end
	else if(cnt	==	N)
		data_all	<=	data_all+register[wr_cnt]-register[rd_cnt]	;
	else
		data_all	<=	data_all+register[wr_cnt]	;
end
always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		data_aver	<=	'd0;
	end
	else if(cnt	==	N)
		data_aver	<=	data_all/(N-1);
	else
		data_aver	<=	'd0	;
end

always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)
		data_out	<=	'd0;	
	else 
		data_out	<=	data_aver	;
end
// 控制RAM的读写数据
//write data
always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==	1'b0)begin
		wr_cnt_r	<=	0	;
	end 
	else if(wr_cnt_r	==RAM_DEPTH-1)
		wr_cnt_r	<=	0	;
	else if(wr_reg)begin
		wr_cnt_r	<=	wr_cnt_r+1'b1;
	end 
	else
		wr_cnt_r	<=	wr_cnt_r	;
end
always@(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)begin
		wr_cnt	<=	'd0;
	end
	else begin
		wr_cnt	<=	wr_cnt_r	;
	end 
end
//read data
always@(posedge	clk	or	negedge	rst_n)	begin
	if(rst_n	==	1'b0)begin
		rd_cnt	<=	0	;
	end 
	else if(rd_cnt	==RAM_DEPTH-1)
		rd_cnt	<=	0	;
	else if(rd_reg)begin
		rd_cnt	<=	rd_cnt+1'b1;
	end 
	else
		rd_cnt	<=	rd_cnt	;
end
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
























