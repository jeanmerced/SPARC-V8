`include "register_32bit.v"
//`include "muxes.v"
`include "PSR_register.v"
`include "TBR_register.v"
`include "alu.v"
`include "registerfile.v"
`include "condition_tester.v"
`include "shifter_and_sign_extender.v"
`include "ram.v"
module DataPath(

// IR
input IR_enable, IR_Clr,
output [31:0] IR_Out,

// Register File
input RF_enable,
output [31:0] RF_PA, RF_PB,

// MAR
input MAR_enable, MAR_Clr,
output [31:0] MAR_Out,

// MDR
input MDR_enable, MDR_Clr,
output [31:0] MDR_Out,

// PC
input PC_enable, PC_Clr,
output [31:0] PC_Out,

// nPC
input nPC_enable, nPC_Clr,
output [31:0] nPC_Out,

// PSR
input PSR_enable, PSR_Clr,
output [31:0] PSR_Out,

// TBR
input TBR_enable, TBR_Clr,
output [31:0] TBR_Out,

// WIM
input WIM_enable, WIM_Clr,
output [31:0] WIM_Out,

// RAM
input MOV,
output MOC,
output [31:0] RAM_Data_Out,

// ALU
output [31:0] ALU_Out,
output N, Z, V, C,

// Shifter & Sign Extender
input [1:0] SSE_select,
output [31:0] SSE_Out,

// Condition Tester
input CT_select,
output COND,

// ALU Mux A
input [2:0] ALU_Mux_A_select,
output [31:0] ALU_Mux_A_Out,

// ALU Mux B
input [2:0] ALU_Mux_B_select,
output [31:0] ALU_Mux_B_Out,

// ALU Mux Op
input ALU_Mux_Op_select,
output [5:0] ALU_Mux_Op_Out,

// RF Mux A
input [1:0] RF_Mux_A_select,
output [4:0] RF_Mux_A_Out,

// RF Mux C
input [1:0] RF_Mux_C_select,
output [4:0] RF_Mux_C_Out,

// MDR Mux
input MDR_Mux_select,
output [31:0] MDR_Mux_Out,

// PC Mux
input [1:0] PC_Mux_select,
output [31:0] PC_Mux_Out,

// PSR Mux
input [2:0] PSR_Mux_select,
output [31:0] PSR_Mux_Out,

// TBR Mux
input TBR_Mux_select,
output [31:0] TBR_Mux_Out,

// RAM Mux Op
input RAM_Mux_Op_select,
output [5:0] RAM_Mux_Op_Out,

// Op5
input [5:0] Op5,

// Clock
input Clk
);

//******Registers******//

register_32bit IR(IR_Out, RAM_Data_Out, IR_enable, IR_Clr, Clk);
register_32bit MAR(MAR_Out, ALU_Out, MAR_enable, MAR_Clr, Clk);
register_32bit MDR(MDR_Out, MDR_Mux_Out, MDR_enable, MDR_Clr, Clk);
register_32bit PC(PC_Out, PC_Mux_Out, PC_enable, PC_Clr, Clk);
register_32bit nPC(nPC_Out, ALU_Out, nPC_enable, nPC_Clr, Clk);
PSR_register PSR(PSR_Out, PSR_Mux_Out, PSR_enable, PSR_Clr, Clk);
TBR_register TBR(TBR_Out, TBR_Mux_Out, TBR_enable, TBR_Clr, Clk);
register_32bit WIM(WIM_Out, ALU_Out, WIM_enable, WIM_Clr, Clk);

//******Components******//

RegisterFile RegisterFile(RF_PA, RF_PB, ALU_Out, RF_Mux_A_Out, IR_Out[4:0], RF_Mux_C_Out, PSR_Out[4:0], RF_enable, 1'b0, Clk);

ALU ALU(ALU_Out, N, Z, V, C, ALU_Mux_Op_Out, ALU_Mux_A_Out, ALU_Mux_B_Out, PSR_Out[20]);

ShifterAndSignExtender SSE(SSE_Out, IR_Out, SSE_select);

ConditionTester CT(COND, IR_Out, PSR_Out[23:20], CT_select, PSR_Out[7], PSR_Out[5]);

ram512x8 RAM(RAM_Data_Out, MOC, MOV, RAM_Mux_Op_Out, MAR_Out, MDR_Out);

//******Muxes******//

mux_32bit_8x1 ALU_Mux_A(ALU_Mux_A_Out, ALU_Mux_A_select, RF_PA, PC_Out, nPC_Out, PSR_Out, TBR_Out, 32'b0, WIM_Out, 32'b1);

mux_32bit_8x1 ALU_Mux_B(ALU_Mux_B_Out, ALU_Mux_B_select, RF_PB, SSE_Out, MDR_Out, 32'h4, 32'b1, 32'b0, 32'h7, 32'hzzzzzzzz);

mux_6bit_2x1 ALU_Mux_Op(ALU_Mux_Op_Out, ALU_Mux_Op_select, Op5, IR_Out[24:19]);

mux_5bit_4x1 RF_Mux_A(RF_Mux_A_Out, RF_Mux_A_select, IR_Out[18:14], IR_Out[29:25], 5'b10001, 5'b10010);

mux_5bit_4x1 RF_Mux_C(RF_Mux_C_Out, RF_Mux_C_select, IR_Out[29:25], 5'b01111, 5'b10001, 5'b10010);

mux_32bit_2x1 MDR_Mux(MDR_Mux_Out, MDR_Mux_select, RAM_Data_Out, ALU_Out);

mux_32bit_4x1 PC_Mux(PC_Mux_Out, PC_Mux_select, nPC_Out, ALU_Out, TBR_Out, 32'hzzzzzzzz);

mux_32bit_8x1 PSR_Mux(PSR_Mux_Out, PSR_Mux_select, {PSR_Out[31:24],N,Z,V,C,PSR_Out[19:0]}, {PSR_Out[31:8],ALU_Out[7],PSR_Out[6:0]}, {PSR_Out[31:7],ALU_Out[7],PSR_Out[5:0]}, {PSR_Out[31:6],ALU_Out[5],PSR_Out[4:0]}, {PSR_Out[31:5], ALU_Out[4:0]}, ALU_Out, 32'hzzzzzzzz, 32'hzzzzzzzz);

mux_32bit_2x1 TBR_Mux(TBR_Mux_Out, TBR_Mux_select, {ALU_Out[31:7],TBR_Out[6:0]},{TBR_Out[31:7],ALU_Out[2:0],TBR_Out[3:0]});

mux_6bit_2x1 RAM_Mux_Op(RAM_Mux_Op_Out, RAM_Mux_Op_select, Op5, IR_Out[24:19]);

endmodule
