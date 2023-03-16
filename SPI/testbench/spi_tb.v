`timescale 1ns/1ns

`define sin_data_file "./sin_12bit.txt"

module spi_tb;

	reg clk;
	reg rst_n;
	reg start;
	reg [2:0]channel;
	
	wire SCLK;
	wire DIN;
	wire CS_N;
	reg DOUT;
	
	wire done;
	wire [11:0]data;
	
	reg [11:0]memory[4095:0];//测试波形数据存储空间
	
	reg [11:0]address;//存储器地址 

	spi spi_inst(
		.clk(clk),
		.rst_n(rst_n),
		.start(start),
		.channel(channel),
	
	//========ADC128S022===========//
		.SCLK(SCLK),
		.DIN(DIN),
		.CS_N(CS_N),
		.DOUT(DOUT),
	
		.done(done),
		.data(data)
);
	
	initial clk = 1'b1;
	always#10 clk = ~clk;

	initial $readmemh(`sin_data_file,memory);//读取原始波形数据读到memory中

	integer i;
	
	initial begin
		rst_n = 1'b0;
		channel = 'd0;
		start = 1'b0;
		DOUT = 1'b0;
		address = 0;
		#100;
		rst_n = 1'b1;
		#100;
		channel = 3;
		for(i=0;i<3;i=i+1)begin
			for(address=0;address<4095;address=address+1)begin
				start = 1;
				#20;
				start = 0;
				gene_DOUT(memory[address]);	//依次将存储器中存储的波形读出，按照ADC的转换结果输出方式送到DOUT信号线上
				@(posedge done);	//等待转换完成信号
				#200;
			end
		end
		#20000;
		$stop;
	end	

		
	//将并行数据按照ADC的数据输出格式，送到DOUT信号线上，供控制模块采集读取
	task gene_DOUT;
		input [15:0]vdata;
		reg [4:0]cnt;
		begin
			cnt = 0;
			wait(!CS_N);
			while(cnt<16)begin
				@(negedge SCLK) DOUT = vdata[15-cnt];
				cnt = cnt + 1'b1;
			end
		end
	endtask
	

endmodule 
