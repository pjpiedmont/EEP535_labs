module char_to_seg7(leds, char);
	output logic[6:0] leds;
	input  logic[7:0] char;
	
	always_comb begin
		case (char)
			" ": leds = 7'b111_1111;
			"0": leds = 7'b1000000;
			"1": leds = 7'b1111001;
			"2": leds = 7'b0100100;
			"3": leds = 7'b0110000;
			"4": leds = 7'b0011001;
			"5": leds = 7'b0010010;
			"6": leds = 7'b0000010;
			"7": leds = 7'b1111000;
			"8": leds = 7'b0000000;
			"9": leds = 7'b0010000;
			"A", "a": leds = 7'b000_1000;
			"B", "b": leds = 7'b000_0011;
			"C", "c": leds = 7'b100_0110;
			"D", "d": leds = 7'b010_0001;
			"E", "e": leds = 7'b000_0110;
			"F", "f": leds = 7'b000_1110;
			"G", "g": leds = 7'b100_0010;
			"H", "h": leds = 7'b000_1011;
			"I", "i": leds = 7'b111_1001;
			"J", "j": leds = 7'b110_0001;
			"L", "l": leds = 7'b100_0111;
			"N", "n": leds = 7'b010_1011;
			"O", "o": leds = 7'b010_0011;
			"P", "p": leds = 7'b000_1100;
			"Q", "q": leds = 7'b001_1000;
			"R", "r": leds = 7'b010_1111;
			"S", "s": leds = 7'b001_0010;
			"T", "t": leds = 7'b000_0111;
			"U", "u": leds = 7'b110_0011;
			"Y", "y": leds = 7'b001_0001;
			"Z", "z": leds = 7'b010_0100;
			default: leds = 7'b111_0111;
		endcase
	end
endmodule