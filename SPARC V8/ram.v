
//———————————————————————————————————————-——————————PARAMETERS———————————————————————————————————————-——————————//
//	DataOut	: 32-bit bus output for operation out 					
//	MOC		: 1-bit output that indicates the memory has completed the operation			
//	MOV		: 1-bit input provided by the CU that indicates when the memory should start operating				
//	Op3		: 6-bit opcode used to determine the operation to be executed							
//	MAR		: 32-bit address given by the MAR register to determine the location on memory						
//	DataIn		: 32-bit input bus that serves input data															
//———————————————————————————————————————-————————————————————————————————————————————————————————-————————————-//

module ram512x8(output reg[31:0] DataOut, output reg MOC, input MOV, input[5:0] Op3, input[31:0] MAR, input[31:0] DataIn);
	
	reg[7:0] Mem[0:511];
	reg[31:0] Address;

	always@(posedge MOV)
		begin
			MOC <= 0;
			Address <= MAR;
			case(Op3)
				6'b001001: //lsb load sign byte
					begin
						#6;
						DataOut[7:0] <= Mem[Address];

						if(Mem[Address][7] == 1)
								DataOut[31:8] <= 24'hffffff;
						else
								DataOut[31:8] <= 24'h000000;
					
						MOC <= 1;
						#2;
						MOC <= 0;

					end							

				6'b001010: //ldsh load sign halfword
					begin
						#6;
						Address[0]	  <= 0;
						DataOut[15:8] <= Mem[Address];
						DataOut[7:0] 	<= Mem[Address + 1];

						if(Mem[Address][7] == 1)
								DataOut[31:16] <= 16'hffff;
						else
								DataOut[31:16] <= 16'h0000;

						MOC <= 1;
						#2;
						MOC <= 0;

					end

				6'b000000: //ld load word
					begin
						#6;
						Address[1:0]	 <= 2'b00;
						DataOut[31:24] <= Mem[Address];
						DataOut[23:16] <= Mem[Address + 1];
						DataOut[15:8]	 <= Mem[Address + 2];
						DataOut[7:0]	 <= Mem[Address + 3];
						MOC		 <= 1;
						#2;
						MOC <= 0;
					end

				6'b000001: //ldub load unsigned byte
					begin
						#6;
						DataOut[31:8]	<= 24'h000000;
						DataOut[7:0]	<= Mem[Address];
						MOC		<= 1;
						#2;
						MOC <= 0;
					end

				6'b000010: //lduh load unsigned halfword
					begin
						#6;
						Address[0]	   <= 0;
						DataOut[31:16] <= 16'h0000;
						DataOut[15:8]  <= Mem[Address];
						DataOut[7:0]   <= Mem[Address + 1];
						MOC		<= 1;
						#2;
						MOC <= 0;

					end

			//	6'b000011: //ldd load double
				
				6'b000101: //stb store byte
					begin
						#6;
						Mem[Address] <= DataIn[7:0];
						MOC			 <= 1;
						#2;
						MOC <= 0;
					end

				6'b000110: //sth store halfword
					begin
						#6;
						Address[0]		  <= 0;
						Mem[Address]	  <= DataIn[15:8];
						Mem[Address + 1] <= DataIn[7:0];
						MOC				  <= 1;
						#2;
						MOC <= 0;
					end

				6'b000100: //st store word
					begin
						#6;
						Address[1:0]	  <= 2'b00;
						Mem[Address]	  <= DataIn[31:24];
						Mem[Address + 1] <= DataIn[23:16];
						Mem[Address + 2] <= DataIn[15:8];
						Mem[Address + 3] <= DataIn[7:0];
						MOC				  <= 1;
						#2;
						MOC <= 0;
					end
					
			//	6'b000111: //std store double

				default: $display("Error: Unknown Opcode");
		endcase
	end
endmodule
