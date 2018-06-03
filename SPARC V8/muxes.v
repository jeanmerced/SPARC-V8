// 1bit 4x1 Multiplexer
module mux_1bit_4x1(output reg out, input[1:0] select, input in0, in1, in2, in3);
	always @ (select, in0, in1, in2, in3)
		case(select)
			2'b00: out = in0; 
			2'b01: out = in1; 
			2'b10: out = in2; 
			2'b11: out = in3; 
		endcase
endmodule

// 5bit 4x1 Multiplexer
module mux_5bit_4x1(output reg [4:0] out, input[1:0] select, input[4:0] in0, in1, in2, in3);
	always @ (select, in0, in1, in2, in3) 
		case(select)
			2'b00: out = in0; 
			2'b01: out = in1; 
			2'b10: out = in2; 
			2'b11: out = in3; 
		endcase
endmodule

// 6bit 2x1 Multiplexer
module mux_6bit_2x1(output reg [5:0] out, input select, input[5:0] in0, in1);
	always @ (select, in0, in1)
		if(select)
			out = in1;
		else
			out = in0;
endmodule

// 8bit 4x1 Multiplexer
module mux_8bit_4x1(output reg [7:0] out, input[1:0] select, input[7:0] in0, in1, in2, in3);
	always @ (select, in0, in1, in2, in3)
		case(select)
			2'b00: out = in0; 
			2'b01: out = in1; 
			2'b10: out = in2; 
			2'b11: out = in3; 
		endcase
endmodule

// 32bit 2x1 Multiplexer
module mux_32bit_2x1(output reg [31:0] out, input select, input[31:0] in0, in1);
	always @ (select, in0, in1) 
		if(select) 
			out = in1; 
		else 
			out = in0; 
endmodule

// 32bit 4x1 Multiplexer
module mux_32bit_4x1(output reg [31:0] out, input[1:0] select, input[31:0] in0, in1, in2, in3); 
	always @ (select, in0, in1, in2, in3) 
		case(select)
			2'b00: out = in0; 
			2'b01: out = in1; 
			2'b10: out = in2; 
			2'b11: out = in3;
		endcase
endmodule

// 32bit 8x1 Multiplexer
module mux_32bit_8x1(output reg[31:0] out, input[2:0] select, input[31:0] in0, in1, in2, in3, in4, in5, in6, in7); 
	always @ (select, in0, in1, in2, in3, in4, in5, in6, in7) 
		case(select)
			3'b000: out = in0; 
			3'b001: out = in1; 
			3'b010: out = in2; 
			3'b011: out = in3; 
			3'b100: out = in4; 
			3'b101: out = in5; 
			3'b110: out = in6; 
			3'b111: out = in7;
		endcase
endmodule

// 32bit 32x1 Multiplexer
module mux_32bit_32x1(output reg[31:0] out, input[4:0] select, input[31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31); 
	always @ (select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31) 
		case(select)
			5'b00000: out = in0; 
			5'b00001: out = in1; 
			5'b00010: out = in2; 
			5'b00011: out = in3; 
			5'b00100: out = in4; 
			5'b00101: out = in5; 
			5'b00110: out = in6; 
			5'b00111: out = in7;
			5'b01000: out = in8; 
			5'b01001: out = in9; 
			5'b01010: out = in10; 
			5'b01011: out = in11; 
			5'b01100: out = in12; 
			5'b01101: out = in13; 
			5'b01110: out = in14; 
			5'b01111: out = in15;
			5'b10000: out = in16; 
			5'b10001: out = in17; 
			5'b10010: out = in18; 
			5'b10011: out = in19; 
			5'b10100: out = in20; 
			5'b10101: out = in21; 
			5'b10110: out = in22; 
			5'b10111: out = in23;
			5'b11000: out = in24; 
			5'b11001: out = in25;
			5'b11010: out = in26; 
			5'b11011: out = in27; 
			5'b11100: out = in28; 
			5'b11101: out = in29; 
			5'b11110: out = in30;
			5'b11111: out = in31;
		endcase
endmodule
