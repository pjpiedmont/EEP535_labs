/**
 * DE1_SoC.sv
 *
 * This module defines the I/Os for the DE-1 SoC board and connects the 7-segment display decoder modules to the hardware.
 *
 * Inputs:
 * - SW: Switches on the DE-1 SoC board.
 * - KEY: Push buttons on the DE-1 SoC board.
 *
 * Outputs:
 * - HEX0 to HEX5: Seven-segment displays on the DE-1 SoC board.
 * - LEDR: LEDs on the DE-1 SoC board.
 */
module DE1_SoC (
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic [9:0] LEDR,
	input  logic [3:0] KEY,
	input  logic [9:0] SW
);	
	// Turn off seven-segment displays
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
	seg7 digit0(.leds(HEX0), .digit(SW[3:0]));
	seg7 digit1(.leds(HEX1), .digit(SW[7:4]));
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	int i;
	initial begin
		for (i = 0; i < 2 ** 8; i++) begin
			SW[7:0] = i; #10;
		end
	end
endmodule