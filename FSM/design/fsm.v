

module fsm(
	input				clk				,
	input				rst_n			,
	input	[7:0]		data			,
	
	output	reg			flag			
);
	localparam
	idle	=			6'b000001		,
	s		=			6'b000010		,
	t1		=			6'b000100		,
	a		=			6'b001000		,
	t2		=			6'b010000		,
	e		=			6'b100000		;

	reg		[5:0]		c_state			;
	reg		[5:0]		n_state			;
	
///////////////////////////////////
//第一段状态机--时序逻辑
always@(posedge	clk	or	negedge	rst_n)	begin

	if(!rst_n)
		c_state	<=	idle	;
	else
		c_state	<= n_state	;	
end

//第二段状态机--组合逻辑
always@(*)	begin
	case(c_state)
		idle:begin
			if(data=="s")
				n_state	=	s	;
			else
				n_state	=	idle	;
		end
		s:begin 
			if(data	==	"t")
				n_state	=	t1	;
			else if(data	==	"s")
				n_state	=	s;
			else
				n_state	=	idle	;				
		end
		t1:begin
			if(data=="a")
				n_state	=	a	;
			else if(data=="s")
				n_state	=	s	;
			else 
				n_state	=	idle	;
		end
		
		a:begin
			if(data=="t")
				n_state	=	t2	;
			else if(data=="s")
				n_state	=	s	;
			else 
				n_state	=	idle	;
		end
		
		t2:begin
			if(data=="e")
				n_state	=	e	;
			else if(data=="s")
				n_state	=	s	;
			else 
				n_state	=	idle	;
		end
		e:begin
			if(data=="s")
				n_state	=	s	;			
			else 
				n_state	=	idle	;
		end
		default:n_state	=	idle	;
	endcase
end
//第三段--时序逻辑
always@(posedge	clk	or	negedge	rst_n)begin
	if(!rst_n)
		flag<=	1'b0	;
	else	begin
		if(n_state	==	e)
			flag	<=	1'b1;
		else
			flag	<=	1'b0;
		end
end


endmodule
























