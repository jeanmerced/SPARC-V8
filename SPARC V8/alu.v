				
//———————————————————————————————————————-——————————PARAMETERS———————————————————————————————————————-——————————//
//	Out	: 32-bit bus output for operation out 					
//	N	: 1-bit output status for Negative Flag			
//	Z	: 1-bit output status for Zero Flag				
//	V	: 1-bit output status for Overflow Flag								
//	C	: 1-bit output status for Carry Flag												
//	Op3	: 6-bit input bus which serves as OpCode (op3)							
//	A	: 32-bit input bus that serves as rs1								
//	B	: 32-bit input bus that serves as rs2 or simm13						
// 	Cin	: 1-bit input carry										
//———————————————————————————————————————-————————————————————————————————————————————————————————-————————————-//

module ALU(output reg [31:0]Out, output reg N, Z, V, C, input [5:0]Op3, input [31:0]A, input [31:0]B, input Cin);

	reg carry;		// Out’s carry

	always @(Op3, A, B, Cin)
		begin
			if(A === 32'hxxxxxxxx || B === 32'hxxxxxxxx || Cin === 1'bx)
				begin
					Out = 32'h00000000;
				end
			else

				casex(Op3)						// if Op3[4] == 1 then condition codes are affected 
					
					6'b0?0000:					// add & addcc 
						begin
							{carry, Out} = A + B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?0001:					// and & andcc
						begin
							Out = A & B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?0010:					// or & orcc
						begin
							Out = A | B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?0011:					// xor & xorcc	
						begin
							Out = A ^ B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?0100:					// sub & subcc					
						begin
							{carry, Out} = A - B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?0101:					// andn & andncc
						begin
							Out = A & ~B; 
							if(Op3[4])
								updateFlags();
						end

					6'b0?0110:					// orn & orncc
						begin
							Out = A | ~B; 
							if(Op3[4])
								updateFlags();
						end
	
					6'b0?0111:					// xorn & xorncc
						begin
							Out = A ^ ~B;
							if(Op3[4])
								updateFlags();
						end

					6'b0?1000:					// addx & addxcc
						begin	
							{carry, Out} = A + B + Cin;
							if(Op3[4])
								updateFlags();
						end

					6'b0?1100:					// subx & subxcc
						begin
							{carry, Out} = A - B - Cin;
							if(Op3[4])
								updateFlags();
						end

					6'b100101:
						Out = (A << B[4:0]);
							
					6'b100110:	
						Out = (A >> B[4:0]);		

					6'b100111:
						Out = $signed(A) >>> (B & 32'h0000001F);
				
				endcase
		end


	// Task for updating the condition codes
	task updateFlags;
		begin
			casex(Op3)
				6'b???000: 					// add operation
					begin
						Z = (Out == 0);
						N = Out[31];
						C = carry;
						V = ((A[31] == B[31]) && (Out[31] != A[31]));
					end

				6'b???100:					// sub operation
					begin
						Z = (Out == 0);
						N = Out[31];
						C = carry;
						V = ((A[31] != B[31]) && (A[31] != Out[31]));
					end
				
				default:					// logical operation
					begin
						Z = (Out == 0);
						N = Out[31];
						C = 0;
						V = 0;
					end

			endcase
		end
	endtask		
endmodule
