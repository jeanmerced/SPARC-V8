module inverter(output reg inverted, input status, input enable);
	always @ (status or enable)
		inverted = (enable) ? ~status : status;
endmodule