`timescale 1ns/1ns
`define	clock_period	20

module tb_fsm;

reg				clk		;
reg				rst_n	;
reg		[7:0]	data	;
       
wire			flag	;

	fsm	fsm_inst(
	.clk	(clk	)		,
	.rst_n	(rst_n	)	,
	.data	(data	)	,	
	.flag	(flag	)	
);

always #(`clock_period/2)clk	=	~	clk	;

initial	begin
	clk		=		1		;
	rst_n	=		0		;
	data	=		0		;
	#100;
	rst_n	=		1		;
	#200;
	data	=		"a"		;
	#(`clock_period)		;
	
	data	=		"s"		;
	#(`clock_period)		;
	
	data	=		"t"		;
	#(`clock_period)		;
	
	data	=		"a"		;
	#(`clock_period)		;
	
	data	=		"t"		;
	#(`clock_period)		;
	
	data	=		"t"		;
	#(`clock_period)		;
	
	
	
	data	=		"s"		;
	#(`clock_period)		;
	data	=		"t"		;
	#(`clock_period)		;
	data	=		"a"		;
	#(`clock_period)		;
	data	=		"t"		;
	#(`clock_period)		;	
	data	=		"e"		;
	#(`clock_period)		;
	
	
	
	
	data	=		"a"		;
	#(`clock_period)		;
	data	=		"a"		;
	#(`clock_period)		;
	
end









endmodule