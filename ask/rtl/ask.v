module ask(clk , rst , x, y);
 
	input	clk,rst;
	input	x;
	
	reg [1:0] cnt;
	reg carry = 0;
 
	output y; 	//wire类型
	
	//第一步：分频得到载波信号序列：carry，（4分频）
	always@(posedge clk)
		begin
			if(!rst)	//rst低电平有效：置位为0可以重置cnt、carry初值
				begin
				 cnt <= 0;
				 carry <= 0;
				end
			else	
				begin	//高电平：3、0；低电平：1、2
					if(cnt == 3 ) //先判断cnt是否为3：	令carry =1
						begin
							cnt <= 0;
							carry <= 1;
						end
					else if(cnt == 0)	//0：	令carry = 1
						begin
							carry <= 1;
							cnt <= cnt + 1;
						end
					else				//1、2：	令carry = 0	
						begin
							cnt = cnt + 1;
							carry <= 0;
						end
				end
		end
			
	//第二步：基带信号x、载波信号carry，&&
	assign	y = x && carry;
 
endmodule