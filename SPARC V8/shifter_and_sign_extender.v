//———————————————————————————————————————-——————————PARAMETERS———————————————————————————————————————-——————————//
//	out		: 32-bit bus output for operation out 					
//	IR		: 32-bit bus input for Instruction Register									
//	SSE_select	: 1-bit input for selecting operation								
//———————————————————————————————————————-————————————————————————————————————————————————————————-————————————-//

module ShifterAndSignExtender(output [31:0] out, input wire[31:0] IR, input[1:0] SSE_select);

	wire[31:0] se13to32_out, eimm22lsb0_out, m4disp22_out, m4disp30_out; 

	sign_extender_13to32 se13to32(se13to32_out, IR[12:0]);
	extender_imm22_lsb_0 eimm22lsb0(eimm22lsb0_out, IR[21:0]);
	mult_4_disp22 m4disp22(m4disp22_out, IR[21:0]);
	mult_4_disp30 m4disp30(m4disp30_out, IR[29:0]);

	mux_32bit_4x1 mux(out, SSE_select, se13to32_out, eimm22lsb0_out, m4disp22_out, m4disp30_out); 
endmodule

// 13bit to 32bit sign extender
module sign_extender_13to32(output [31:0] out, input[12:0] in);
	assign out[31:13] = {19{in[12]}};
	assign out[12:0]  = in[12:0];
endmodule

// extends imm22 with least significant bits equal to zero
module extender_imm22_lsb_0(output [31:0] out, input[21:0] in);
	assign out[31:10] = in;
	assign out[9:0]  = 10'b0000000000;
endmodule

// multiplies 4 times disp22
module mult_4_disp22(output [31:0] out, input[21:0] in);
	assign out[31:24] = {8{in[21]}};
	assign out[23:2]  = in;
	assign out[1:0]   = 2'b00;
endmodule

// multiplies 4 times disp30
module mult_4_disp30(output [31:0] out, input[29:0] in);
	assign out[31:2] = in;
	assign out[1:0]  = 2'b00;
endmodule
