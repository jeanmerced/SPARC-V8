module Microstore(

	//control signals enables
	output reg IR_enable, RF_enable, MAR_enable, MDR_enable, MOV, PC_enable, nPC_enable, PSR_enable, TBR_enable, WIM_enable,

	//clear signals
	output reg Clr,

	//Mux select
	output reg MDR_Mux_select, RAM_Mux_Op_select, TBR_Mux_select, ALU_Mux_Op_select, Inv, CT_select,
	output reg [1:0]RF_Mux_C_select, RF_Mux_A_select, PC_Mux_select, SSE_select, Sts_select,
	output reg [2:0]ALU_Mux_A_select, ALU_Mux_B_select, PSR_Mux_select, NS_select,

	output reg [5:0]Op5,
	output reg [7:0]Pl7,
	output reg [7:0]CurrentState,

	//State
	input [7:0] NextState 
	);

	//reg [7:0] NextState;

	always @ (NextState)
	begin
		//NextState = (RESET) ? 8'b0 : inState;

		case (NextState)
			//***********
			//*  RESET  *
			//***********
			8'b00000000://0
			begin
				Clr <= 1;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000001;
				CurrentState <= NextState;
			end
			
			8'b00000001://1
			begin
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b101;
				ALU_Mux_B_select <= 3'b011;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				Clr <= 0;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00000010://2
			begin
				nPC_enable <= 0;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			//***********************
			
						
			//***********
			//*  FETCH  *
			//***********
			8'b00000011://3
			begin
				MAR_enable <= 1;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				RAM_Mux_Op_select <= 0;
				NS_select <= 3'b011;
				CurrentState <= NextState;				
			end		

			8'b00000100://4
			begin
				MAR_enable <= 0;	
				MOV <= 1;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00000101://5
			begin
				IR_enable <= 1;
				MOV <= 0;
				NS_select <= 3'b110;
				Inv <= 0;
				Sts_select <= 2'b00;
				Pl7 <= 8'b00000101;
				CurrentState <= NextState;
			end

			8'b00000110://6
			begin
				IR_enable <=0;
				CT_select <= 0;
				NS_select <= 3'b100;
				Inv <= 1;
				Sts_select <= 2'b01;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************

									
			//***********
			//*  Sethi  *
			//***********
			8'b00000111://7
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b101;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b01;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00001000://8
			begin
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end

			//***********************


			//***********
			//* BRANCH	*
			//***********
			8'b00001001://9
			begin
				CT_select <= 1;
				NS_select <= 3'b110;
				Inv <= 0;
				Sts_select <= 2'b01;
				Pl7 <= 8'b00001100;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//* BX TRUE	*
			//***********
			8'b00001010://10
			begin
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b10;
				Op5 <= 6'b000000;
				PC_enable <= 1;
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00001011://11
			begin
				PC_enable <= 0;
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***********************


			//************
			//* BX FALSE *
			//************
			8'b00001100://12
			begin
				
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b010;
				ALU_Mux_B_select <= 3'b011;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				PC_enable <= 1;
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00001101://13
			begin
				
				PC_enable <= 0;
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***********************


			//********************
			//* BRANCH ANNULLED  *
			//********************
			8'b00001110://14
			begin
				CT_select <= 1;
				NS_select <= 3'b110;
				Inv <= 1;
				Sts_select <= 2'b01;
				Pl7 <= 8'b00001010;
				CurrentState <= NextState;
			end
			//***********************


			//*********************
			//* BX FALSE ANNULLED *
			//*********************
			
			8'b00001111://15
			begin
				PC_enable <= 1;
				ALU_Mux_A_select <= 3'b010;
				ALU_Mux_B_select <= 3'b011;
				ALU_Mux_Op_select <= 0;
				PC_Mux_select <= 2'b01;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00010000://16
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b011;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00010001://17
			begin
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***********************
				
				
			//***********
			//*  CALL   *
			//***********
			

			8'b00010010://18
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b01;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00010011://19
			begin
				RF_enable <= 0;
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b11;
				Op5 <= 6'b000000;
				PC_enable <= 1;
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00010100://20
			begin
				PC_enable <= 0;
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  JMPL.  *
			//***********
			8'b00010101://21
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			

			8'b00010110://22
			begin
				RF_enable <= 0;
				PC_enable <= 1;
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b110;
				Inv <= 1;
				Sts_select <= 2'b10;
				Pl7 <= 8'b00011000;
				CurrentState <= NextState;
			end

			8'b00010111://23
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b00011001;
				CurrentState <= NextState;
			end

			8'b00011000://24
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00011001://25
			begin
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;

            		end
			//***************************


			//***********
			//*  Save   *
			//***********
			8'b00011010://26
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b00011100;
				CurrentState <= NextState;
			end
			
			8'b00011011://27
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select = 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00011100://28
			begin
				RF_enable <= 0;
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				PSR_Mux_select = 3'b100;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000100;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00011101://29
			begin
				PSR_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//* RESTORE *
			//***********
			8'b00011110://30
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b00100000;
				CurrentState <= NextState;
			end
			
			8'b00011111://31
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select = 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00100000://32
			begin
				RF_enable <= 0;
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				PSR_Mux_select = 3'b100;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00100001://33
			begin
				PSR_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;			
			end			
			//***********************


			//***************
			//* ARITH/LOGIC *
			//***************
			8'b00100010://34
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 1;
				NS_select <= 3'b010;
				Pl7 <= 8'b00100110;
				CurrentState <= NextState;
			end

            		8'b00100011://35
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 1;
				SSE_select = 2'b00;
				NS_select <= 3'b010;
				Pl7 <= 8'b00100110;
				CurrentState <= NextState;
			end

			8'b00100100://36
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 1;
				PSR_Mux_select <= 3'b000;
				PSR_enable <= 1;
				NS_select <= 3'b010;
				Pl7 <= 8'b00100110;
				CurrentState <= NextState;
			end

            		8'b00100101://37
			begin
				RF_enable <= 1;
				RF_Mux_C_select = 2'b00;
				RF_Mux_A_select = 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 1;
				SSE_select = 2'b00;
				PSR_Mux_select <= 3'b000;
				PSR_enable <= 1;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

            		8'b00100110://38
			begin
				PSR_enable <= 0;
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  LOAD   *
			//***********
			8'b00100111://39
			begin
				MAR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				RAM_Mux_Op_select <= 1;
				NS_select <= 3'b010;
				Pl7 <= 8'b00101001;
				CurrentState <= NextState;
			end
			
			8'b00101000://40
			begin
				MAR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000000;
				RAM_Mux_Op_select <= 1;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00101001://41
			begin
				MAR_enable <= 0;
				MDR_Mux_select <= 0;
				MDR_enable <= 1;
				RAM_Mux_Op_select <= 1;
				MOV <= 1;
				NS_select <= 3'b110;
				Inv <= 0;
				Sts_select <= 2'b00;
				Pl7 <= 8'b00101001;
				CurrentState <= NextState;
			end

			8'b00101010://42
			begin
				RF_enable <= 1;
				MDR_enable <= 0;
				MOV <= 0;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b101;
				ALU_Mux_B_select <= 3'b010;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00101011://43
			begin
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  STORE  *
			//***********
			8'b00101100://44
			begin
				MAR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b00101110;
				CurrentState <= NextState;
			end
			
			8'b00101101://45
			begin
				MAR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00101110://46
			begin
				MAR_enable <= 0;
				MDR_enable <= 1;
				RF_Mux_A_select <= 2'b01;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				MDR_Mux_select <= 1;
				Op5 <= 6'b000000;
				RAM_Mux_Op_select <= 1;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00101111://47
			begin
				RAM_Mux_Op_select <= 1;
				MDR_enable <= 0;
				MOV <= 1;
				NS_select <= 3'b110;
				Inv <= 0;
				Sts_select <= 2'b00;
				Pl7 <= 8'b00101111;
				CurrentState <= NextState;
			end

			8'b00110000://48
			begin
				MOV <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end			
			//***********************


			//***********
			//*  RDPSR  *
			//***********
			8'b00110001://49
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			

			8'b00110010://50
			begin
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end	
			//***********************


			//***********
			//*  RDWIM  *
			//***********
			8'b00110011://51
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b110;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b00110100://52
			begin
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end	
			//***********************


			//***********
			//*  RDTBR  *
			//***********
			8'b00110101://53
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b00;
				ALU_Mux_A_select <= 3'b100;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00110110://54
			begin
				RF_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  WRPSR  *
			//***********
			8'b00110111://55
			begin
				PSR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b101;
				Op5 <= 6'b000011;
				NS_select <= 3'b010;
				Pl7 <= 8'b00111001;
				CurrentState <= NextState;
			end
			
			8'b00111000://56
			begin
				PSR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b101;
				SSE_select <= 2'b00;
				Op5 <= 6'b000011;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00111001://57
			begin
				PSR_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  WRWIM  *
			//***********
			8'b00111010://58
			begin
				WIM_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000011;
				NS_select <= 3'b010;
				Pl7 <= 8'b00111100;
				CurrentState <= NextState;
			end

			8'b00111011://59
			begin
				WIM_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000011;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00111100://60
			begin
				WIM_enable <= 0;
				NS_select <= 3'b010;;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end
			//***************************


			//***********
			//*  WRTBR  *
			//***********
			8'b00111101://61
			begin
				TBR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				TBR_Mux_select <= 0;
				Op5 <= 6'b000011;
				NS_select <= 3'b010;
				Pl7 <= 8'b00111111;
				CurrentState <= NextState;			
			end

			8'b00111110://62
			begin
				TBR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				TBR_Mux_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000011;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b00111111://63
			begin
				TBR_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010011;
				CurrentState <= NextState;
			end			
			//***********************


			//**********************
			//*  Priority Manager  *
			//**********************
			8'b01000000://64
			begin
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			//***********
			//*  Ticc   *
			//***********
			8'b01000001://65
			begin
				TBR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				TBR_Mux_select <= 1;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b01000011;
				CurrentState <= NextState;
			end

			8'b01000010://66
			begin
				TBR_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				TBR_Mux_select <= 1;
				SSE_select <= 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01000011://67
			begin
				PSR_enable <= 1;
				TBR_enable <= 0;
				ALU_Mux_A_select <= 3'b101;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b011;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b01000100://68
			begin
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b010;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;			
			end

			8'b01000101://69
			begin
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b111;
				ALU_Mux_B_select <= 3'b110;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b001;
				Op5 <= 6'b100101;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01000110://70
			begin
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b100;
				Op5 <= 6'b000100;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01000111://71
			begin
				RF_enable <= 1;
				PSR_enable <= 0;
				RF_Mux_C_select <= 2'b10;
				ALU_Mux_A_select <= 3'b001;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01001000://72
			begin
				RF_enable <= 1;
				RF_Mux_C_select <= 2'b11;
				ALU_Mux_A_select <= 3'b010;
				ALU_Mux_B_select <= 3'b101;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01001001://73
			begin
				RF_enable <= 0;	
				PC_enable <= 1;
				PC_Mux_select <= 2'b10;	
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b01001010://74
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01001011://75
			begin
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***********************


			//***********
			//*  RETT   *
			//***********
			
			8'b01001100://76
			begin
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b100;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01001101://77
			begin
				PC_enable <= 1;
				PSR_enable <= 0;
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b110;
				Inv <= 1;
				Sts_select <= 2'b10;
				Pl7 <= 8'b01100100;
				CurrentState <= NextState;
			end

			8'b01001110://78
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b000;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b010;
				Pl7 <= 8'b01010000;
				CurrentState <= NextState;
				
			end

			8'b01001111://79
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				RF_Mux_A_select <= 2'b00;
				ALU_Mux_A_select <= 3'b000;
				ALU_Mux_B_select <= 3'b001;
				ALU_Mux_Op_select <= 0;
				SSE_select <= 2'b00;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;				
			end

			8'b01010000://80
			begin
				nPC_enable <= 0;
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b011;
				ALU_Mux_B_select <= 3'b100;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b001;
				Op5 <= 6'b100101;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01010001://81
			begin
				PSR_enable <= 1;
				ALU_Mux_A_select <= 3'b101;
				ALU_Mux_B_select <= 3'b100;
				ALU_Mux_Op_select <= 0;
				PSR_Mux_select <= 3'b011;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01010010://82
			begin
				PSR_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end
			//***************************


			//************************
			//*   Instruction Flow   *
			//************************
			8'b01010011://83
			begin
				PC_enable <= 1;				
				PC_Mux_select <= 2'b00;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end

			8'b01010100://84
			begin
				PC_enable <= 0;
				nPC_enable <= 1;
				ALU_Mux_A_select <= 3'b010;
				ALU_Mux_B_select <= 3'b011;
				ALU_Mux_Op_select <= 0;
				Op5 <= 6'b000000;
				NS_select <= 3'b011;
				CurrentState <= NextState;
			end
			
			8'b01010101://85
			begin
				nPC_enable <= 0;
				NS_select <= 3'b010;
				Pl7 <= 8'b00000011;
				CurrentState <= NextState;
			end			
		endcase
	end
endmodule
