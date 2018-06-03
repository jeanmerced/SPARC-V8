module NextStateSelector(output reg [1:0]M, input [2:0]N, input Sts);
always @ (N, Sts)
	begin
		M[1] <= N[1]|(Sts&N[2]);
		M[0] <= (~N[2]&N[0])|(N[0]&Sts)|(N[2]&N[1]&Sts);
	end
endmodule