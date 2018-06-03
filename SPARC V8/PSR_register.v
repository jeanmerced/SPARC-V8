module PSR_register(output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);

initial
	out <= 32'hf0000020;
		
always @ (posedge Clk, posedge Clr)
	if(Clr) 
		out <= 32'hf0000020; 
	else if(enable) 
		out <= in; 
endmodule 
