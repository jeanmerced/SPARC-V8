module incrementerx1(output reg [7:0] incremented, input [7:0] number);
	always @ (number)
		incremented = number + 1;
endmodule