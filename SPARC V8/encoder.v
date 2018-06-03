module encoder(output reg [7:0] state, input wire [31:0] IR);
always @ (IR)
	casex(IR[31:19])
		13'b00?????100???: 					
			state = 8'b00000111;			// sethi

		13'b000????010???: 				
			state = 8'b00001001; 			// branch

		13'b001????010???: 				
			state = 8'b00001110; 			// branch annulled
				
		13'b01???????????:
			state = 8'b00010010;			// call

		13'b10?????111000:
			state = 8'b00010101;			// jmpl

		13'b10?????111100:
			begin
				if(IR[13] == 0)
					state = 8'b00011010;	 
				else				// save
					state = 8'b00011011;	
			end	


		13'b10?????111101:
			begin
				if(IR[13] == 0)
					state = 8'b00011110;	 
				else				// restore
					state = 8'b00011111;	
			end	

		13'b10?????000000:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// add
					state = 8'b00100011;	
			end	
		
		13'b10?????010000:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// addcc
					state = 8'b00100101;	
			end				

		13'b10?????001000:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// addx
					state = 8'b00100011;	
			end	

		13'b10?????011000:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// addxcc
					state = 8'b00100101;	
			end	

		13'b10?????000100:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// sub
					state = 8'b00100011;	
			end	


		13'b10?????010100:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// subcc
					state = 8'b00100101;	
			end	

		13'b10?????001100:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// subx
					state = 8'b00100011;	
			end	
			
		13'b10?????011100:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// subxcc
					state = 8'b00100101;	
			end	

		13'b10?????000001:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// and
					state = 8'b00100011;	
			end	
		
		13'b10?????010001:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// andcc
					state = 8'b00100101;	
			end	

		13'b10?????000101:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// andn
					state = 8'b00100011;	
			end	

		13'b10?????010101:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// andncc
					state = 8'b00100101;	
			end	

		13'b10?????000010:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// or
					state = 8'b00100011;	
			end	


		13'b10?????010010:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// orcc
					state = 8'b00100101;	
			end	

		13'b10?????000110:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// orn
					state = 8'b00100011;	
			end	

		13'b10?????010110:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// orncc
					state = 8'b00100101;	
			end	

		13'b10?????000011:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// xor
					state = 8'b00100011;	
			end	

		13'b10?????010011:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// xorcc
					state = 8'b00100101;	
			end	

		13'b10?????000111:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// xorn
					state = 8'b00100011;	
			end	

		13'b10?????010111:
			begin
				if(IR[13] == 0)
					state = 8'b00100100;	 
				else				// xorncc
					state = 8'b00100101;	
			end	

		13'b10?????100101:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// sll
					state = 8'b00100011;	
			end	


		13'b10?????100110:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// srl
					state = 8'b00100011;	
			end	

		13'b10?????100111:
			begin
				if(IR[13] == 0)
					state = 8'b00100010;	 
				else				// sra
					state = 8'b00100011;	
			end	


		13'b11?????001001:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// lsb
					state = 8'b00101000;	
			end	
		
		13'b11?????001010:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// ldsh
					state = 8'b00101000;	
			end				

		13'b11?????000000:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// ld
					state = 8'b00101000;	
			end				

		13'b11?????000001:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// ldub
					state = 8'b00101000;	
			end				

		13'b11?????000010:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// lduh
					state = 8'b00101000;	
			end				

		13'b11?????000011:
			begin
				if(IR[13] == 0)
					state = 8'b00100111;	 
				else				// ldd
					state = 8'b00101000;	
			end				

		13'b11?????000101:
			begin
				if(IR[13] == 0)
					state = 8'b00101100;	 
				else				// stb
					state = 8'b00101101;	
			end				

		13'b11?????000110:
			begin
				if(IR[13] == 0)
					state = 8'b00101100;	 
				else				// sth
					state = 8'b00101101;	
			end				

		13'b11?????000100:
			begin
				if(IR[13] == 0)
					state = 8'b00101100;	 
				else				// st
					state = 8'b00101101;	
			end				

		13'b11?????000111:
			begin
				if(IR[13] == 0)
					state = 8'b00101100;	 
				else				// std
					state = 8'b00101101;	
			end				

		13'b10?????101001:
			state = 8'b00110001;			// RDPSR

		13'b10?????101010:
			state = 8'b00110011;			// RDWIM
	
		13'b10?????101011:
			state = 8'b00110101;			// RDTBR

		13'b10?????110001:
			begin
				if(IR[13] == 0)
					state = 8'b00110111;	 
				else				// WRPSR
					state = 8'b00111000;
			end				
	
		13'b10?????110010:
			begin
				if(IR[13] == 0)
					state = 8'b00111010;	 
				else				// WRWIM
					state = 8'b00111011;
			end			

		13'b10?????110011:
			begin
				if(IR[13] == 0)
					state = 8'b00111101;	 
				else				// WRTBR
					state = 8'b00111110;
			end				

		13'b10?????111010:
			state = 8'b01000000;			// ticc

		13'b10?????111001:
			state = 8'b01000000;			// rett

		//default:
			//state = ;				// illegal instruction
	endcase
endmodule			
