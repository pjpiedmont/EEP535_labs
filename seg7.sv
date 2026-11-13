module seg7 #(
	parameter bit ACTIVE_LOW = 1
)(
	logic [3:0] digit,
	logic [6:0] leds
);
	logic [6:0] ledsInternal;

	always_comb begin
		// exhaustive
		case (digit)
			4'h0: ledsInternal = 7'b0111111;
			4'h1: ledsInternal = 7'b0000110;
			4'h2: ledsInternal = 7'b1011011;
			4'h3: ledsInternal = 7'b1001111;
			4'h4: ledsInternal = 7'b1100110;
			4'h5: ledsInternal = 7'b1101101;
			4'h6: ledsInternal = 7'b1111101;
			4'h7: ledsInternal = 7'b0000111;
			4'h8: ledsInternal = 7'b1111111;
			4'h9: ledsInternal = 7'b1101111;
			4'ha: ledsInternal = 7'b1110111;
			4'hb: ledsInternal = 7'b1111100;
			4'hc: ledsInternal = 7'b0111001;
			4'hd: ledsInternal = 7'b1011110;
			4'he: ledsInternal = 7'b1111001;
			4'hf: ledsInternal = 7'b1110001;
		endcase

		if (ACTIVE_LOW)
			leds = ~ledsInternal;
		else
			leds = ledsInternal;
	end
endmodule