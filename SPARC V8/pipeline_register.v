module Pipeline_register(

//control signals enables
output reg IR_enable, RF_enable, MAR_enable, MDR_enable, MOV, PC_enable, nPC_enable, PSR_enable, TBR_enable, WIM_enable,

//clear signals
output reg Clr,

//Mux select
output reg MDR_Mux, RAM_Mux_Op, TBR_Mux, ALU_Mux_Op, Inv, CT_select,
output reg [1:0]RF_Mux_C, RF_Mux_A, PC_Mux, SSE_select, Sts_select,
output reg [2:0]ALU_Mux_A, ALU_Mux_B, PSR_Mux, NS_select,

output reg [5:0]Op5,
output reg [7:0]Pl7,
output reg [7:0]CurrentState,

//control signals enables
input IR_enable_in, RF_enable_in, MAR_enable_in, MDR_enable_in, MOV_in, PC_enable_in, nPC_enable_in, PSR_enable_in, TBR_enable_in, WIM_enable_in,

//clear signals
input Clr_in,

//Mux select
input MDR_Mux_in, RAM_Mux_Op_in, TBR_Mux_in, ALU_Mux_Op_in, Inv_in, CT_select_in,
input [1:0]RF_Mux_C_in, RF_Mux_A_in, PC_Mux_in, SSE_select_in, Sts_select_in,
input [2:0]ALU_Mux_A_in, ALU_Mux_B_in, PSR_Mux_in, NS_select_in,

input [5:0]Op5_in,
input [7:0]Pl7_in,
input [7:0]CurrentState_in,

input Clk
);

always @ (posedge Clk)
	begin
		IR_enable <= IR_enable_in;
		RF_enable <= RF_enable_in;
		MAR_enable <= MAR_enable_in;
		MDR_enable <= MDR_enable_in;
		MOV <= MOV_in;
		PC_enable <= PC_enable_in;
		nPC_enable <= nPC_enable_in;
		PSR_enable <= PSR_enable_in;
		TBR_enable <= TBR_enable_in;
		WIM_enable <= WIM_enable_in;
		Clr <= Clr_in;
		MDR_Mux <= MDR_Mux_in;; 
		RAM_Mux_Op <= RAM_Mux_Op_in;
		TBR_Mux <= TBR_Mux_in;
		ALU_Mux_Op <= ALU_Mux_Op_in;
		Inv <= Inv_in;
		CT_select <= CT_select_in;
		RF_Mux_C <= RF_Mux_C_in;
		RF_Mux_A <= RF_Mux_A_in;
		PC_Mux <= PC_Mux_in;
		SSE_select <= SSE_select_in;
		Sts_select <= Sts_select_in;
		ALU_Mux_A <= ALU_Mux_A_in;
		ALU_Mux_B <= ALU_Mux_B_in;
		PSR_Mux <= PSR_Mux_in;
		NS_select <= NS_select_in;
		Op5 <= Op5_in;
		Pl7 <= Pl7_in;
		CurrentState <= CurrentState_in;
	end
endmodule
