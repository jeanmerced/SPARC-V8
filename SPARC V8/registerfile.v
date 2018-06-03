`include "decoder.v"
//———————————————————————————————————————-——————————PARAMETERS———————————————————————————————————————-——————————//
//	RF_PA	: 32-bit bus that serves as output for input PA				
//	RF_PB   : 32-bit bus that serves as output for input PB			
//	in	: 32-bit bus for the data to be written				
//	RF_A    : 5-bit address bus that indicates the output of RF_PA							
//	RF_B    : 5-bit address bus that indicates the output of RF_PB									
//	in_PC   : 5-bit address bus that indicates which register will be written						
//	enable  : 1-bit input which indicates RF when it is enabled to operate							
//	Clr     : 1-bit input that serves as a clear signal					
// 	Clk     : 1-bit input representing the system’s clock
//	CWP 	: 1-bit input which indicates the Current Window Pointer									
//———————————————————————————————————————-————————————————————————————————————————————————————————-————————————-//

module RegisterFile(output [31:0]RF_PA,RF_PB, input [31:0] in, input [4:0] RF_A, RF_B, in_PC, CWP, input enable, Clr, Clk);

	//---Enabling the Current Window-------------------------------------------

	wire [3:0]  window_enable; // 4-bit bus that is the output of the enable decoder in charge of choosing the current register window
	
	wire [31:0] w3_reg_enable; // The output of the decoder used for choosing a register in window 3
	wire [31:0] w2_reg_enable; // The output of the decoder used for choosing a register in window 2
	wire [31:0] w1_reg_enable; // The output of the decoder used for choosing a register in window 1
	wire [31:0] w0_reg_enable; // The output of the decoder used for choosing a register in window 0
	

	decoder_2x4 d_window(window_enable, CWP[1:0], enable); // Selecting The window

	// Each one chooses one out of the 32 visible registers in the current window
	decoder_5x32 d3(w3_reg_enable, in_PC, window_enable[3]);
	decoder_5x32 d2(w2_reg_enable, in_PC, window_enable[2]);
	decoder_5x32 d1(w1_reg_enable, in_PC, window_enable[1]);
	decoder_5x32 d0(w0_reg_enable, in_PC, window_enable[0]);
	
	//---Clears-------------------------------------------
	
	wire [3:0]  window_clear; 
	
	wire [31:0] w3_reg_clears;
	wire [31:0] w2_reg_clears;
	wire [31:0] w1_reg_clears;
	wire [31:0] w0_reg_clears; 

	decoder_2x4 d_window_clear(window_clear, CWP[1:0], Clr);
	
	decoder_5x32 c3(w3_reg_clears, in_PC, window_clear[3]);
	decoder_5x32 c2(w2_reg_clears, in_PC, window_clear[2]);
	decoder_5x32 c1(w1_reg_clears, in_PC, window_clear[1]);
	decoder_5x32 c0(w0_reg_clears, in_PC, window_clear[0]);
	
	
	//---Registers Enables and Clears--------------------------------------------------------------------------------------
	
	wire [71:0] reg_enable; // a 72-bit bus for enabling each of the registers
	wire [71:0] reg_clr;  // a 72-bit bus for clearing each of the registers

	// Mux for enabling global registers r0-r7
	mux_8bit_4x1 mux_global(reg_enable[7:0], CWP[1:0], w0_reg_enable[7:0], w1_reg_enable[7:0], w2_reg_enable[7:0], w3_reg_enable[7:0]);
	// Mux for clearing global registers r0-r7
	mux_8bit_4x1 mux_global_clear(reg_clr[7:0], CWP[1:0], w0_reg_clears[7:0], w1_reg_clears[7:0], w2_reg_clears[7:0], w3_reg_clears[7:0]);
	

	// Window 3: Inputs  (r31-r24 window 3) 
	// Window 0: Outputs (r15-r8  window 0) 
	// 71-64  enable,
	or or71 (reg_enable[71], w3_reg_enable[31], w0_reg_enable[15]);
	or or70 (reg_enable[70], w3_reg_enable[30], w0_reg_enable[14]);
	or or69 (reg_enable[69], w3_reg_enable[29], w0_reg_enable[13]);
	or or68 (reg_enable[68], w3_reg_enable[28], w0_reg_enable[12]);
	or or67 (reg_enable[67], w3_reg_enable[27], w0_reg_enable[11]);
	or or66 (reg_enable[66], w3_reg_enable[26], w0_reg_enable[10]);
	or or65 (reg_enable[65], w3_reg_enable[25], w0_reg_enable[9]);
	or or64 (reg_enable[64], w3_reg_enable[24], w0_reg_enable[8]);

	// 71-64 clear,
	or or71_clear (reg_clr[71], w3_reg_clears[31], w0_reg_clears[15]);
	or or70_clear (reg_clr[70], w3_reg_clears[30], w0_reg_clears[14]);
	or or69_clear (reg_clr[69], w3_reg_clears[29], w0_reg_clears[13]);
	or or68_clear (reg_clr[68], w3_reg_clears[28], w0_reg_clears[12]);
	or or67_clear (reg_clr[67], w3_reg_clears[27], w0_reg_clears[11]);
	or or66_clear (reg_clr[66], w3_reg_clears[26], w0_reg_clears[10]);
	or or65_clear (reg_clr[65], w3_reg_clears[25], w0_reg_clears[9]);
	or or64_clear (reg_clr[64], w3_reg_clears[24], w0_reg_clears[8]);

	// Window 3: Local (r23-r16 window 3) 
	// r63-56 enable
	buf buf63  (reg_enable[63], w3_reg_enable[23]); 
	buf buf62  (reg_enable[62], w3_reg_enable[22]); 
	buf buf61  (reg_enable[61], w3_reg_enable[21]); 
	buf buf60  (reg_enable[60], w3_reg_enable[20]); 
	buf buf59  (reg_enable[59], w3_reg_enable[19]); 
	buf buf58  (reg_enable[58], w3_reg_enable[18]);
	buf buf57  (reg_enable[57], w3_reg_enable[17]); 
	buf buf56  (reg_enable[56], w3_reg_enable[16]); 

	// r63-56 clear
	buf buf63_clear  (reg_clr[63], w3_reg_clears[23]); 
	buf buf62_clear  (reg_clr[62], w3_reg_clears[22]); 
	buf buf61_clear  (reg_clr[61], w3_reg_clears[21]); 
	buf buf60_clear  (reg_clr[60], w3_reg_clears[20]); 
	buf buf59_clear  (reg_clr[59], w3_reg_clears[19]); 
	buf buf58_clear  (reg_clr[58], w3_reg_clears[18]); 
	buf buf57_clear  (reg_clr[57], w3_reg_clears[17]); 
	buf buf56_clear  (reg_clr[56], w3_reg_clears[16]); 

	// Window 3: Outputs (r15-r8  window 3)
	// Window 2: Inputs  (r31-r24 window 2) 
	// r55-48 enable,
	or or55 (reg_enable[55], w3_reg_enable[15],  w2_reg_enable[31]);
	or or54 (reg_enable[54], w3_reg_enable[14],  w2_reg_enable[30]);
	or or53 (reg_enable[53], w3_reg_enable[13],  w2_reg_enable[29]);
	or or52 (reg_enable[52], w3_reg_enable[12],  w2_reg_enable[28]);
	or or51 (reg_enable[51], w3_reg_enable[11],  w2_reg_enable[27]);
	or or50 (reg_enable[50], w3_reg_enable[10],  w2_reg_enable[26]);
	or or49 (reg_enable[49], w3_reg_enable[9],  w2_reg_enable[25]);
	or or48 (reg_enable[48], w3_reg_enable[8],  w2_reg_enable[24]);

	// r55-48 clear,
	or or55_clear (reg_clr[55], w3_reg_clears[15],  w2_reg_clears[31]);
	or or54_clear (reg_clr[54], w3_reg_clears[14],  w2_reg_clears[30]);
	or or53_clear (reg_clr[53], w3_reg_clears[13],  w2_reg_clears[29]);
	or or52_clear (reg_clr[52], w3_reg_clears[12],  w2_reg_clears[28]);
	or or51_clear (reg_clr[51], w3_reg_clears[11],  w2_reg_clears[27]);
	or or50_clear (reg_clr[50], w3_reg_clears[10],  w2_reg_clears[26]);
	or or49_clear (reg_clr[49], w3_reg_clears[9],  w2_reg_clears[25]);
	or or48_clear (reg_clr[48], w3_reg_clears[8],  w2_reg_clears[24]);

	// Window 2: Local (r23-r16 window 2) 
	// r47-40 enable,
	buf buf47  (reg_enable[47], w2_reg_enable[23]);
	buf buf46  (reg_enable[46], w2_reg_enable[22]);
	buf buf45  (reg_enable[45], w2_reg_enable[21]);
	buf buf44  (reg_enable[44], w2_reg_enable[20]);
	buf buf43  (reg_enable[43], w2_reg_enable[19]);
	buf buf42  (reg_enable[42], w2_reg_enable[18]);
	buf buf41  (reg_enable[41], w2_reg_enable[17]);
	buf buf40  (reg_enable[40], w2_reg_enable[16]);
	

	// r47-40 clear,
	buf buf47_clear  (reg_clr[47], w2_reg_clears[23]);
	buf buf46_clear  (reg_clr[46], w2_reg_clears[22]);
	buf buf45_clear  (reg_clr[45], w2_reg_clears[21]);
	buf buf44_clear  (reg_clr[44], w2_reg_clears[20]);
	buf buf43_clear  (reg_clr[43], w2_reg_clears[19]);
	buf buf42_clear  (reg_clr[42], w2_reg_clears[18]);
	buf buf41_clear  (reg_clr[41], w2_reg_clears[17]);
	buf buf40_clear  (reg_clr[40], w2_reg_clears[16]);
	
	// Window 2: Outputs (r15-r8  window 2)
	// Window 1: Inputs  (r31-r24 window 1) 
	// r39-32 enable,
	or or39 (reg_enable[39], w2_reg_enable[15], w1_reg_enable[31]);
	or or38 (reg_enable[38], w2_reg_enable[14], w1_reg_enable[30]);
	or or37 (reg_enable[37], w2_reg_enable[13], w1_reg_enable[29]);
	or or36 (reg_enable[36], w2_reg_enable[12], w1_reg_enable[28]);
	or or35 (reg_enable[35], w2_reg_enable[11], w1_reg_enable[27]);
	or or34 (reg_enable[34], w2_reg_enable[10], w1_reg_enable[26]);
	or or33 (reg_enable[33], w2_reg_enable[9], w1_reg_enable[25]);
	or or32 (reg_enable[32], w2_reg_enable[8], w1_reg_enable[24]);

	// r39-32 clear,
	or or39_clear (reg_clr[39], w2_reg_clears[15], w1_reg_clears[31]);
	or or38_clear (reg_clr[38], w2_reg_clears[14], w1_reg_clears[30]);
	or or37_clear (reg_clr[37], w2_reg_clears[13], w1_reg_clears[29]);
	or or36_clear (reg_clr[36], w2_reg_clears[12], w1_reg_clears[28]);
	or or35_clear (reg_clr[35], w2_reg_clears[11], w1_reg_clears[27]);
	or or34_clear (reg_clr[34], w2_reg_clears[10], w1_reg_clears[26]);
	or or33_clear (reg_clr[33], w2_reg_clears[9], w1_reg_clears[25]);
	or or32_clear (reg_clr[32], w2_reg_clears[8], w1_reg_clears[24]);

	// Window 1: Local (r23-r16 del window 1) 
	// r31-24 enable,
	buf buf31  (reg_enable[31], w1_reg_enable[23]);
	buf buf30  (reg_enable[30], w1_reg_enable[22]);
	buf buf29  (reg_enable[29], w1_reg_enable[21]);
	buf buf28  (reg_enable[28], w1_reg_enable[20]);
	buf buf27  (reg_enable[27], w1_reg_enable[19]);
	buf buf26  (reg_enable[26], w1_reg_enable[18]);
	buf buf25  (reg_enable[25], w1_reg_enable[17]);
	buf buf24  (reg_enable[24], w1_reg_enable[16]);

	// r31-24 clear,
	buf buf31_clear  (reg_clr[31], w1_reg_clears[23]);
	buf buf30_clear  (reg_clr[30], w1_reg_clears[22]);
	buf buf29_clear  (reg_clr[29], w1_reg_clears[21]);
	buf buf28_clear  (reg_clr[28], w1_reg_clears[20]);
	buf buf27_clear  (reg_clr[27], w1_reg_clears[19]);
	buf buf26_clear  (reg_clr[26], w1_reg_clears[18]);
	buf buf25_clear  (reg_clr[25], w1_reg_clears[17]);
	buf buf24_clear  (reg_clr[24], w1_reg_clears[16]);

	// Window 1: Outputs (r15-r8  del window 1)
	// Window 0: Inputs  (r31-r24 del window 0) 
	// r23-16 enable,
	or or23 (reg_enable[23], w1_reg_enable[15], w0_reg_enable[31]);
	or or22 (reg_enable[22], w1_reg_enable[14], w0_reg_enable[30]);
	or or21 (reg_enable[21], w1_reg_enable[13], w0_reg_enable[29]);
	or or20 (reg_enable[20], w1_reg_enable[12], w0_reg_enable[28]);
	or or19 (reg_enable[19], w1_reg_enable[11], w0_reg_enable[27]);
	or or18 (reg_enable[18], w1_reg_enable[10], w0_reg_enable[26]);
	or or17 (reg_enable[17], w1_reg_enable[9], w0_reg_enable[25]);
	or or16 (reg_enable[16], w1_reg_enable[8], w0_reg_enable[24]);

	// r23-16 clear,
	or or23_clear (reg_clr[23], w1_reg_clears[15], w0_reg_clears[23]);
	or or22_clear (reg_clr[22], w1_reg_clears[14], w0_reg_clears[22]);
	or or21_clear (reg_clr[21], w1_reg_clears[13], w0_reg_clears[21]);
	or or20_clear (reg_clr[20], w1_reg_clears[12], w0_reg_clears[20]);
	or or19_clear (reg_clr[19], w1_reg_clears[11], w0_reg_clears[19]);
	or or18_clear (reg_clr[18], w1_reg_clears[10], w0_reg_clears[18]);
	or or17_clear (reg_clr[17], w1_reg_clears[9], w0_reg_clears[17]);
	or or16_clear (reg_clr[16], w1_reg_clears[8], w0_reg_clears[16]);

	// Window 0: Local (r23-r16 del window 0) 
	// r15-8 enable,
	buf buf15  (reg_enable[15], w0_reg_enable[23]);
	buf buf14  (reg_enable[14], w0_reg_enable[22]);
	buf buf13  (reg_enable[13], w0_reg_enable[21]);
	buf buf12  (reg_enable[12], w0_reg_enable[20]);
	buf buf11  (reg_enable[11], w0_reg_enable[19]);
	buf buf10  (reg_enable[10], w0_reg_enable[18]);
	buf buf9   (reg_enable[9],  w0_reg_enable[17]);
	buf buf8   (reg_enable[8],  w0_reg_enable[16]);

	// r15-8 clear,
	buf buf15_clear  (reg_clr[15], w0_reg_clears[23]);
	buf buf14_clear  (reg_clr[14], w0_reg_clears[22]);
	buf buf13_clear  (reg_clr[13], w0_reg_clears[21]);
	buf buf12_clear  (reg_clr[12], w0_reg_clears[20]);
	buf buf11_clear  (reg_clr[11], w0_reg_clears[19]);
	buf buf10_clear  (reg_clr[10], w0_reg_clears[18]);
	buf buf9_clear   (reg_clr[9],  w0_reg_clears[17]);
	buf buf8_clear   (reg_clr[8],  w0_reg_clears[16]);



	//---Initialising  registers-----------------------------------------------------------------------------------------------------

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers

	// Global Registers r0-r7
	register_32bit r7  (r_out[7],  in, reg_enable[7], reg_clr[7], Clk);
	register_32bit r6  (r_out[6],  in, reg_enable[6], reg_clr[6], Clk);
	register_32bit r5  (r_out[5],  in, reg_enable[5], reg_clr[5], Clk);
	register_32bit r4  (r_out[4],  in, reg_enable[4], reg_clr[4], Clk);
	register_32bit r3  (r_out[3],  in, reg_enable[3], reg_clr[3], Clk);
	register_32bit r2  (r_out[2],  in, reg_enable[2], reg_clr[2], Clk);
	register_32bit r1  (r_out[1],  in, reg_enable[1], reg_clr[1], Clk);
	register_32bit r0  (r_out[0], 32'h00000000, 1'b1, reg_clr[0], Clk);
	
	// Variable registers

	// Window 3: Inputs  (r31-r24 del window 3) 
	// Window 0: Outputs (r15-r8  del window 0) 
	register_32bit r71 (r_out[71], in, reg_enable[71], reg_clr[71], Clk);
	register_32bit r70 (r_out[70], in, reg_enable[70], reg_clr[70], Clk);
	register_32bit r69 (r_out[69], in, reg_enable[69], reg_clr[69], Clk);
	register_32bit r68 (r_out[68], in, reg_enable[68], reg_clr[68], Clk);
	register_32bit r67 (r_out[67], in, reg_enable[67], reg_clr[67], Clk);
	register_32bit r66 (r_out[66], in, reg_enable[66], reg_clr[66], Clk);
	register_32bit r65 (r_out[65], in, reg_enable[65], reg_clr[65], Clk);
	register_32bit r64 (r_out[64], in, reg_enable[64], reg_clr[64], Clk);
	
	// Window 3: Local (r23-r16 del window 3) 
	register_32bit r63 (r_out[63], in, reg_enable[63], reg_clr[63], Clk);
	register_32bit r62 (r_out[62], in, reg_enable[62], reg_clr[62], Clk);
	register_32bit r61 (r_out[61], in, reg_enable[61], reg_clr[61], Clk);
	register_32bit r60 (r_out[60], in, reg_enable[60], reg_clr[60], Clk);
	register_32bit r59 (r_out[59], in, reg_enable[59], reg_clr[59], Clk);
	register_32bit r58 (r_out[58], in, reg_enable[58], reg_clr[58], Clk);
	register_32bit r57 (r_out[57], in, reg_enable[57], reg_clr[57], Clk);
	register_32bit r56 (r_out[56], in, reg_enable[56], reg_clr[56], Clk);

	// Window 3: Outputs (r15-r8  del window 3)
	// Window 2: Inputs  (r31-r24 del window 2) 
	register_32bit r55 (r_out[55], in, reg_enable[55], reg_clr[55], Clk);
	register_32bit r54 (r_out[54], in, reg_enable[54], reg_clr[54], Clk);
	register_32bit r53 (r_out[53], in, reg_enable[53], reg_clr[53], Clk);
	register_32bit r52 (r_out[52], in, reg_enable[52], reg_clr[52], Clk);
	register_32bit r51 (r_out[51], in, reg_enable[51], reg_clr[51], Clk);
	register_32bit r50 (r_out[50], in, reg_enable[50], reg_clr[50], Clk);
	register_32bit r49 (r_out[49], in, reg_enable[49], reg_clr[49], Clk);
	register_32bit r48 (r_out[48], in, reg_enable[48], reg_clr[48], Clk);
	
	// Window 2: Local (r23-r16 del window 2) 
	register_32bit r47 (r_out[47], in, reg_enable[47], reg_clr[47], Clk);
	register_32bit r46 (r_out[46], in, reg_enable[46], reg_clr[46], Clk);
	register_32bit r45 (r_out[45], in, reg_enable[45], reg_clr[45], Clk);
	register_32bit r44 (r_out[44], in, reg_enable[44], reg_clr[44], Clk);
	register_32bit r43 (r_out[43], in, reg_enable[43], reg_clr[43], Clk);
	register_32bit r42 (r_out[42], in, reg_enable[42], reg_clr[42], Clk);
	register_32bit r41 (r_out[41], in, reg_enable[41], reg_clr[41], Clk);
	register_32bit r40 (r_out[40], in, reg_enable[40], reg_clr[40], Clk);

	// Window 2: Outputs (r15-r8  del window 2)
	// Window 1: Inputs  (r31-r24 del window 1) 
	register_32bit r39 (r_out[39], in, reg_enable[39], reg_clr[39], Clk);
	register_32bit r38 (r_out[38], in, reg_enable[38], reg_clr[38], Clk);
	register_32bit r37 (r_out[37], in, reg_enable[37], reg_clr[37], Clk);
	register_32bit r36 (r_out[36], in, reg_enable[36], reg_clr[36], Clk);
	register_32bit r35 (r_out[35], in, reg_enable[35], reg_clr[35], Clk);
	register_32bit r34 (r_out[34], in, reg_enable[34], reg_clr[34], Clk);
	register_32bit r33 (r_out[33], in, reg_enable[33], reg_clr[33], Clk);
	register_32bit r32 (r_out[32], in, reg_enable[32], reg_clr[32], Clk);
	
	
	// Window 1: Local (r23-r16 del window 1) 
	register_32bit r31 (r_out[31], in, reg_enable[31], reg_clr[31], Clk);
	register_32bit r30 (r_out[30], in, reg_enable[30], reg_clr[30], Clk);
	register_32bit r29 (r_out[29], in, reg_enable[29], reg_clr[29], Clk);
	register_32bit r28 (r_out[28], in, reg_enable[28], reg_clr[28], Clk);
	register_32bit r27 (r_out[27], in, reg_enable[27], reg_clr[27], Clk);
	register_32bit r26 (r_out[26], in, reg_enable[26], reg_clr[26], Clk);
	register_32bit r25 (r_out[25], in, reg_enable[25], reg_clr[25], Clk);
	register_32bit r24 (r_out[24], in, reg_enable[24], reg_clr[24], Clk);	
	
	// Window 1: Outputs (r15-r8  del window 1)
	// Window 0: Inputs  (r31-r24 del window 0) 
	register_32bit r23 (r_out[23], in, reg_enable[23], reg_clr[23], Clk);
	register_32bit r22 (r_out[22], in, reg_enable[22], reg_clr[22], Clk);
	register_32bit r21 (r_out[21], in, reg_enable[21], reg_clr[21], Clk);
	register_32bit r20 (r_out[20], in, reg_enable[20], reg_clr[20], Clk);
	register_32bit r19 (r_out[19], in, reg_enable[19], reg_clr[19], Clk);
	register_32bit r18 (r_out[18], in, reg_enable[18], reg_clr[18], Clk);
	register_32bit r17 (r_out[17], in, reg_enable[17], reg_clr[17], Clk);
	register_32bit r16 (r_out[16], in, reg_enable[16], reg_clr[16], Clk);
	
	// Window 0: Local (r23-r16 del window 0) 
	register_32bit r15 (r_out[15], in, reg_enable[15], reg_clr[15], Clk);
	register_32bit r14 (r_out[14], in, reg_enable[14], reg_clr[14], Clk);
	register_32bit r13 (r_out[13], in, reg_enable[13], reg_clr[13], Clk);
	register_32bit r12 (r_out[12], in, reg_enable[12], reg_clr[12], Clk);
	register_32bit r11 (r_out[11], in, reg_enable[11], reg_clr[11], Clk);
	register_32bit r10 (r_out[10], in, reg_enable[10], reg_clr[10], Clk);
	register_32bit r9  (r_out[9],  in, reg_enable[9],  reg_clr[9], Clk);
	register_32bit r8  (r_out[8],  in, reg_enable[8],  reg_clr[8], Clk);



	//---Selecting Register out from the CWP----------------------------------------------------
	// Port A
	
	wire [31:0] mux_window_out0A;
	wire [31:0] mux_window_out1A;
	wire [31:0] mux_window_out2A;
	wire [31:0] mux_window_out3A;

	mux_32bit_32x1 mux_window0A(mux_window_out0A, RF_A, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[64],  r_out[65],  r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71], 
		r_out[8], r_out[9], r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15],
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23]
		);

	mux_32bit_32x1 mux_window1A(mux_window_out1A, RF_A, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31],
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39]
		);
		
	mux_32bit_32x1 mux_window2A(mux_window_out2A, RF_A, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47],
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55]
		);

	mux_32bit_32x1 mux_window3A(mux_window_out3A, RF_A, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[48],  r_out[49],  r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63],
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71]
		);
	
	// Output for PA
	mux_32bit_4x1  mux_resultA(RF_PA, CWP[1:0], mux_window_out0A, mux_window_out1A, mux_window_out2A, mux_window_out3A);
	
	// Port B
	
	wire [31:0] mux_window_out0B;
	wire [31:0] mux_window_out1B;
	wire [31:0] mux_window_out2B;
	wire [31:0] mux_window_out3B;

	mux_32bit_32x1 mux_window0B(mux_window_out0B, RF_B, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[64],  r_out[65],  r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71], 
		r_out[8], r_out[9], r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15],
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23]
		);

	mux_32bit_32x1 mux_window1B(mux_window_out1B, RF_B, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31],
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39]
		);
		
	mux_32bit_32x1 mux_window2B(mux_window_out2B, RF_B, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47],
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55]
		);

	mux_32bit_32x1 mux_window3B(mux_window_out3B, RF_B, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[48],  r_out[49],  r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63],
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71]
		);
	
	// Output for PB
	mux_32bit_4x1  mux_resultB(RF_PB, CWP[1:0], mux_window_out0B, mux_window_out1B, mux_window_out2B, mux_window_out3B);

endmodule
