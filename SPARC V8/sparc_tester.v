`include "controlunit.v"
`include "datapath.v"
module sparc_tester;

// IR
wire IR_enable;
wire [31:0] IR_Out;

// Register File
wire RF_enable;
wire [31:0] RF_PA, RF_PB;

// MAR
wire MAR_enable, MAR_Clr;
wire [31:0] MAR_Out;

// MDR
wire MDR_enable, MDR_Clr;
wire [31:0] MDR_Out;

// PC
wire PC_enable, PC_Clr;
wire [31:0] PC_Out;

// nPC
wire nPC_enable, nPC_Clr;
wire [31:0] nPC_Out;

// PSR
wire PSR_enable, PSR_Clr;
wire [31:0] PSR_Out;

// TBR
wire TBR_enable, TBR_Clr;
wire [31:0] TBR_Out;

// WIM
wire WIM_enable, WIM_Clr;
wire [31:0] WIM_Out;

// RAM
wire MOV;
wire MOC;
wire [31:0] RAM_Data_Out;

// ALU
wire [31:0] ALU_Out;
wire Z, N, C, V;

// Shifter & Sign Extender
wire [1:0] SSE_select;
wire [31:0] SSE_Out;

// Condition Tester
wire CT_select;
wire COND;

// ALU Mux A
wire [2:0] ALU_Mux_A_select;
wire [31:0] ALU_Mux_A_Out;

// ALU Mux B
wire [2:0] ALU_Mux_B_select;
wire [31:0] ALU_Mux_B_Out;

// ALU Mux Op
wire ALU_Mux_Op_select;
wire [5:0] ALU_Mux_Op_Out;

// RF Mux A
wire [1:0] RF_Mux_A_select;
wire [4:0] RF_Mux_A_Out;

// RF Mux C
wire [1:0] RF_Mux_C_select;
wire [4:0] RF_Mux_C_Out;

// MDR Mux
wire MDR_Mux_select;
wire [31:0] MDR_Mux_Out;

// PC Mux
wire [1:0] PC_Mux_select;
wire [31:0] PC_Mux_Out;

// PSR Mux
wire [2:0] PSR_Mux_select;
wire [31:0] PSR_Mux_Out;

// TBR Mux
wire TBR_Mux_select;
wire [31:0] TBR_Mux_Out;

// RAM Mux Op
wire RAM_Mux_Op_select;
wire [5:0] RAM_Mux_Op_Out;

// Op5
wire [5:0] Op5;

wire [7:0] CurrentState;

reg RESET;

wire Clr;

// Clock
reg Clk = 0;

parameter sim_time = 2000; //998;

always begin
		#1 Clk = !Clk;
	end

integer fi, fo, i, positionInMem, data, code;

DataPath DataPath(IR_enable, Clr, IR_Out, RF_enable, RF_PA, RF_PB, MAR_enable, MAR_Clr, MAR_Out, MDR_enable, 
	MDR_Clr, MDR_Out, PC_enable, Clr, PC_Out, nPC_enable, nPC_Clr, nPC_Out, PSR_enable, Clr, PSR_Out, 
	TBR_enable, TBR_Clr, TBR_Out, WIM_enable, Clr, WIM_Out, MOV, MOC, RAM_Data_Out, 
	ALU_Out, N, Z, V, C, SSE_select, SSE_Out, CT_select, COND, ALU_Mux_A_select, ALU_Mux_A_Out, ALU_Mux_B_select, 
	ALU_Mux_B_Out, ALU_Mux_Op_select, ALU_Mux_Op_Out, RF_Mux_A_select, RF_Mux_A_Out, RF_Mux_C_select, RF_Mux_C_Out, 
	MDR_Mux_select, MDR_Mux_Out, PC_Mux_select, PC_Mux_Out, PSR_Mux_select, PSR_Mux_Out, TBR_Mux_select, TBR_Mux_Out, 
	RAM_Mux_Op_select, RAM_Mux_Op_Out, Op5, Clk);

ControlUnit CU(IR_enable, RF_enable, MAR_enable, MDR_enable, MOV, PC_enable, nPC_enable, PSR_enable, TBR_enable, WIM_enable, 
	Clr, MDR_Mux_select, RAM_Mux_Op_select, TBR_Mux_select, ALU_Mux_Op_select, CT_select, RF_Mux_C_select, 
	RF_Mux_A_select, PC_Mux_select, SSE_select, ALU_Mux_A_select, ALU_Mux_B_select, PSR_Mux_select, Op5, CurrentState, 
	IR_Out, MOC, COND, Clk, RESET);


	initial begin
		fo=$fopen("result_tester.txt","w");
	end

	always @ (MAR_Out, DataPath.RAM.Mem[MAR_Out])
		begin
			$fwrite(fo, "Current State = %d Mar_Out = %d, IR_Out = %b\n\n", CurrentState, MAR_Out, IR_Out);
		
			for(i = 0; i<263; i=i+4)
				begin
					$fwrite(fo,"DataPath.RAM.Mem[%0d]= %b %b %b %b\n", i, DataPath.RAM.Mem[i], DataPath.RAM.Mem[i+1], DataPath.RAM.Mem[i+2], DataPath.RAM.Mem[i+3]);
				end
			$fwrite(fo,"\n———————————————————————————————————————————————————————————————\n");
		end


	initial begin
		fi = $fopen("testcode_sparc2.txt","r"); 
		positionInMem = 0;
		$monitor("%b", data);
		while (!($feof(fi)))
		begin
			code = $fscanf(fi, "%b", data);
			DataPath.RAM.Mem[positionInMem] = data[31:24];
			DataPath.RAM.Mem[positionInMem + 1]= data[23:16];
			DataPath.RAM.Mem[positionInMem + 2]= data[15:8];
			DataPath.RAM.Mem[positionInMem + 3]= data[7:0];
			positionInMem = positionInMem + 4;	
			$display("Instruction = %b", data);

		end
		$fclose(fi);
		$display ("State		IR_Out			 MAR_Out       ALU_Out	  PC_Out       nPC_Out");
		$monitor ("%d %b %d %d %d %d", CurrentState, IR_Out, MAR_Out, ALU_Out, PC_Out, nPC_Out);
		#1;
		RESET = 1;
		#1;
		RESET = 0;
	end
		
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule









