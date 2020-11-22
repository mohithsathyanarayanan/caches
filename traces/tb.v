//testbench

`timescale 1ns/1ps
	
module tb;
	
	reg CLK;
		
	cache uut (CLK);
	
	initial begin
	
	$dumpfile ("tb.vcd"); 
	$dumpvars(0,tb);
	CLK =0;
	end
	

	always 
	begin
	#5 CLK = ~CLK;	
	end

	always
	begin
	#10 $finish;
	end

endmodule

























