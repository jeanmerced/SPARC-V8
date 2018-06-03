module register_32bit(output reg[31:0] out, input wire[31:0] in, input wire enable, Clr, Clk);

always @ (posedge Clk, posedge Clr)
	if(Clr) 			// Clr = 1, writes 0 on every bit of the register
		out <= 32'h00000000;
	else if(enable) 
		out <= in; 
endmodule
