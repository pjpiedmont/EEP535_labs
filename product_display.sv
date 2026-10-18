module product_display(leds0, leds1, leds2, leds3, leds4, leds5, u, p, c);
	output logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;
	input  logic       u, p, c;
	
	logic [7:0]  char0, char1, char2, char3, char4, char5;
	logic [47:0] product_name;
	
	char_to_seg7 converter0(.leds(leds0), .char(char0));
	char_to_seg7 converter1(.leds(leds1), .char(char1));
	char_to_seg7 converter2(.leds(leds2), .char(char2));
	char_to_seg7 converter3(.leds(leds3), .char(char3));
	char_to_seg7 converter4(.leds(leds4), .char(char4));
	char_to_seg7 converter5(.leds(leds5), .char(char5));
	
	assign { char5, char4, char3, char2, char1, char0 } = product_name;
	
	always_comb begin
		case ({ u, p, c })
			0: product_name = "bassn ";  // bassoon
			1: product_name = "trbn  ";  // trombone
			3: product_name = "synth ";
			4: product_name = "cello ";
			5: product_name = "piano ";
			6: product_name = "flute ";
			default: product_name = 48'bx;
		endcase
	end
endmodule

module product_display_testbench();
	logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;
	logic       u, p, c;
	
	product_display dut(.leds0, .leds1, .leds2, .leds3, .leds4, .leds5, .u, .p, .c);
	
	int i;
	initial begin
		for (i = 0; i < 8; i++) begin
			{ u, p, c } = i; #10;
		end
	end
endmodule