// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input  logic [3:0] KEY;
	input  logic [9:0] SW;
	
	product_display disp(.leds5(HEX5), .leds4(HEX4), .leds3(HEX3), .leds2(HEX2), .leds1(HEX1), .leds0(HEX0), .u(SW[9]), .p(SW[8]), .c(SW[7]));
	stolen_detector detector(.isStolen(LEDR[0]), .isDiscounted(LEDR[1]), .u(SW[9]), .p(SW[8]), .c(SW[7]), .isMarkPresent(SW[0]));
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .KEY, .SW);
	
	int i;
	initial begin
		for (i = 0; i < 16; i++) begin
			{ SW[9], SW[8], SW[7], SW[0] } = i; #10;
		end
	end
endmodule