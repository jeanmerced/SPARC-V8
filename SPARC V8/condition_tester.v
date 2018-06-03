//———————————————————————————————————————-——————————PARAMETERS———————————————————————————————————————-——————————//
//	cond		: 1-bit output which is the condition statement 					
//	IR		: 32-bit input for Instruction Register		
//	PSR_icc		: 4-bit input for current condition codes in the system				
//	CT_select	: 1-bit input for select tester operation								
//	S		: 1-bit input status for Supervisor Mode
//	ET		: 1-bit	input status for Traps Enabled								
//———————————————————————————————————————-————————————————————————————————————————————————————————-————————————-//

module ConditionTester(output reg cond, input wire[31:0] IR, input wire[3:0] PSR_icc, input CT_select, S, ET);
always @ (CT_select, IR, S, ET)
	begin
		if(CT_select == 0) 
			casex(IR[31:19])

				13'b10?????111010:			// trap
					if(ET == 1)
						cond = 1;
					else
						cond = 0;
				
				//**********SUPERVISOR CONDITIONS**********//

				13'b10?????101001:			// RDPSR
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				13'b10?????101010:			// RDWIM
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				13'b10?????101011:			// RDTBR
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				13'b10?????110001:			// WRPSR
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				13'b10?????110010:			// WRWIM
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				13'b10?????110011:			// WRTBR
					if(S == 1)
						cond = 1;
					else
						cond = 0;

				default:
					cond = 1;
			endcase
		else
			casex(IR[31:19])

				//**********BRANCH CONDITIONS**********//

				13'b0001000010???:			// ba 
					cond = 1;
		
				13'b0011000010???:			// ba annulled
					cond = 0;

				13'b00?0000010???:			// bn
					cond = 0;

				13'b00?1001010???:			// bne
					if(~PSR_icc[2])
						cond = 1;
					else
						cond = 0;

				13'b00?0001010???:			// be
					if(PSR_icc[2])
						cond = 1;
					else
						cond = 0;

				13'b00?1010010???:			// bg
					if(~(PSR_icc[2]|(PSR_icc[3] ^ PSR_icc[1])))
						cond = 1;
					else
						cond = 0;

				13'b00?0010010???:			// ble
					if(PSR_icc[2] | (PSR_icc[3] ^ PSR_icc[1]))
						cond = 1;
					else
						cond = 0;

				13'b00?1011010???:			// bge
					if(~(PSR_icc[3] ^ PSR_icc[1]))
						cond = 1;
					else
						cond = 0;

				13'b00?0011010???:			// bl
					if(PSR_icc[3] ^ PSR_icc[1])
						cond = 1;
					else
						cond = 0;

				13'b00?1100010???:			// bgu
					if(~(PSR_icc[0] | PSR_icc[2]))
						cond = 1;
					else
						cond = 0;

				13'b00?0100010???:			// bleu
					if(PSR_icc[0] | PSR_icc[2])
						cond = 1;
					else
						cond = 0;

				13'b00?1101010???:			// bcc
					if(~PSR_icc[0])
						cond = 1;
					else
						cond = 0;

				13'b00?0101010???:			// bcs
					if(PSR_icc[0])
						cond = 1;
					else
						cond = 0;

				13'b00?1110010???:			// bpos
					if(~PSR_icc[3])
						cond = 1;
					else
						cond = 0;

				13'b00?0110010???:			// bneg
					if(PSR_icc[3])
						cond = 1;
					else
						cond = 0;

				13'b00?1111010???:			// bvc
					if(~PSR_icc[1])
						cond = 1;
					else
						cond = 0;

				13'b00?0111010???:			// bvs
					if(PSR_icc[1])
						cond = 1;
					else
						cond = 0;

				//**********TRAP CONDITIONS**********//

				13'b10?1000111010:			// ta
					cond = 1;
			
				13'b10?0000111010:			// tn
					cond = 0;
	
				13'b10?1001111010:			// tne
					if(~PSR_icc[2])
						cond = 1;
					else 
						cond = 0;

				13'b10?0001111010:			// te
					if(PSR_icc[2])
						cond = 1;
					else 
						cond = 0;

				13'b10?1010111010:			// tg
					if(~(PSR_icc[2]|(PSR_icc[3] ^ PSR_icc[1])))
						cond = 1;
					else 
						cond = 0;

				13'b10?0010111010:			// tle
					if(PSR_icc[2] | (PSR_icc[3] ^ PSR_icc[1]))
						cond = 1;
					else 
						cond = 0;

				13'b10?1011111010:			// tge
					if(~(PSR_icc[3] ^ PSR_icc[1]))
						cond = 1;
					else 
						cond = 0;

				13'b10?0011111010:			// tl
					if(PSR_icc[3] ^ PSR_icc[1])
						cond = 1;
					else 
						cond = 0;

				13'b10?1100111010:			// tgu
					if(~(PSR_icc[0] | PSR_icc[2]))
						cond = 1;
					else 
						cond = 0;

				13'b10?0100111010:			// tleu
					if(PSR_icc[0] | PSR_icc[2])
						cond = 1;
					else 
						cond = 0;

				13'b10?1101111010:			// tcc
					if(~PSR_icc[0])
						cond = 1;
					else 
						cond = 0;

				13'b10?0101111010:			// tcs
					if(PSR_icc[0])
						cond = 1;
					else 
						cond = 0;

				13'b10?1110111010:			// tpos
					if(~PSR_icc[3])
						cond = 1;
					else 
						cond = 0;

				13'b10?0110111010:			// tneg
					if(PSR_icc[3])
						cond = 1;
					else 
						cond = 0;

				13'b10?1111111010:			// tvc
					if(~PSR_icc[1])
						cond = 1;
					else 
						cond = 0;

				13'b10?0111111010:			// tvs
					if(PSR_icc[1])
						cond = 1;
					else 
						cond = 0;
			endcase			
	end
endmodule
