`include "muxes.v"
`include "microstore.v"
`include "encoder.v"
`include "nextstateselect.v"
`include "inverter.v"
`include "incrementer.v"
`include "pipeline_register.v"
`include "register_8bit.v"

module ControlUnit(

	//Enables and clears
	output IR_enable, RF_enable, MAR_enable, MDR_enable, MOV, PC_enable, nPC_enable, PSR_enable, TBR_enable, WIM_enable,
	output Clr,
	
	//Mux Selection
	output MDR_Mux, RAM_Mux_Op, TBR_Mux, ALU_Mux_Op, CT_select,
	output [1:0]RF_Mux_C, RF_Mux_A, PC_Mux, SSE_select,
	output [2:0]ALU_Mux_A, ALU_Mux_B, PSR_Mux,

	output [5:0]Op5,
	output [7:0]CurrentState,
	
	input [31:0]IR,
	input MOC, COND, Clk, RESET
	);

	//-------------MICROSTORE OUTPUTS-------------------------------------------------------------------------------------------
	
	wire mIR_enable, mRF_enable, mMAR_enable, mMDR_enable, mMOV, mPC_enable, mnPC_enable, mPSR_enable, mTBR_enable, mWIM_enable;
	wire mClr;

	wire mMDR_Mux, mRAM_Mux_Op, mTBR_Mux, mALU_Mux_Op, mInv, mCT_select;
	wire [1:0]mRF_Mux_C, mRF_Mux_A, mPC_Mux, mSSE_select, mSts_select;
	wire [2:0]mALU_Mux_A, mALU_Mux_B, mPSR_Mux, mNS_select;
	wire [5:0]mOp5;
	wire [7:0]mPl7;
	wire [7:0]mCurrentState;
	//--------------------------------------------------------------------------------------------------------------------------	

	//Pipeline outputs that stay inside the control unit
	wire Inv;
	wire [1:0] Sts_select; // Selection in sts_mux
	wire [2:0] NS_select; // Selection in Next State Selector
	wire [7:0] Pl7;

	

	wire [7:0] next_state, encoder_out, micro_in;

	wire sts_mux_out, sts;
	wire [1:0] nss_out;
	wire [7:0] incr_out, incrState;
	
	//Instruction encoder 
	encoder encoder(encoder_out, IR);

	//Multiplexer that selects the status that will be evaluated MOC, COND, IR[13], IR[23]
	mux_1bit_4x1 sts_mux(sts_mux_out, Sts_select, MOC, COND, IR[13], IR[23]);

	//Multiplexer that selects the next state that will enter the microstore
	mux_8bit_4x1 state_mux(next_state, nss_out, encoder_out, 8'b0, Pl7, incrState);

	//inverts the status signal when necessary
	inverter inv1 (sts, sts_mux_out, Inv);
	
	//Logic box to manage selection of the state multiplexer
	NextStateSelector nss(nss_out, NS_select, sts);

	//Incrementer and Register
	incrementerx1 incr1(incr_out, next_state);
	register_8bit incrementer_register(incrState, incr_out, 1'b1, 1'b0, Clk);

	//Intermediate register to load next state in the microstore also use for reseting
	register_8bit intermediate(micro_in, next_state, 1'b1, RESET, ~Clk);



	//-----------------MICROSTORE--------------------------------------------------------------------------------------------------------	
	Microstore m1(mIR_enable, mRF_enable, mMAR_enable, mMDR_enable, mMOV, mPC_enable, mnPC_enable, mPSR_enable, mTBR_enable, mWIM_enable,
		mClr, mMDR_Mux, mRAM_Mux_Op, mTBR_Mux, mALU_Mux_Op, mInv, mCT_select, mRF_Mux_C, mRF_Mux_A, mPC_Mux, 
		mSSE_select, mSts_select, mALU_Mux_A, mALU_Mux_B, mPSR_Mux, mNS_select, mOp5, mPl7, mCurrentState, micro_in);
	
	//-----------------PIPELINE REGISTER-------------------------------------------------------------------------------------------------
	Pipeline_register pipereg(
		//outputs of pipeline that are the outputs of the control unit.
		IR_enable, RF_enable, MAR_enable, MDR_enable, MOV, PC_enable, nPC_enable, PSR_enable, TBR_enable, WIM_enable,
		Clr, MDR_Mux, RAM_Mux_Op, TBR_Mux, ALU_Mux_Op, Inv, CT_select, RF_Mux_C, RF_Mux_A, PC_Mux, 
		SSE_select, Sts_select, ALU_Mux_A, ALU_Mux_B, PSR_Mux, NS_select, Op5, Pl7, CurrentState,


		//inputs that come from the microstore
		mIR_enable, mRF_enable, mMAR_enable, mMDR_enable, mMOV, mPC_enable, mnPC_enable, mPSR_enable, mTBR_enable, mWIM_enable,
		mClr, mMDR_Mux, mRAM_Mux_Op, mTBR_Mux, mALU_Mux_Op, mInv, mCT_select, mRF_Mux_C, mRF_Mux_A, mPC_Mux, 
		mSSE_select, mSts_select, mALU_Mux_A, mALU_Mux_B, mPSR_Mux, mNS_select, mOp5, mPl7, mCurrentState, Clk);


endmodule	
