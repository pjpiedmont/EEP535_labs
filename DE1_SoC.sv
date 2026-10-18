/**
 * DE1_SoC.sv
 *
 * This module defines the I/Os for the DE-1 SoC board and connects the digit comparison modules to the hardware.
 *
 * Parameters:
 * - WIDTH: The bit width of the digits to be compared.
 *
 * Inputs:
 * - SW: Switches on the DE-1 SoC board.
 * - KEY: Push buttons on the DE-1 SoC board.
 *
 * Outputs:
 * - HEX0 to HEX5: Seven-segment displays on the DE-1 SoC board.
 * - LEDR: LEDs on the DE-1 SoC board.
 */
module DE1_SoC #(
    parameter WIDTH = 4
)
(
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic [9:0] LEDR,
	input  logic [3:0] KEY,
	input  logic [9:0] SW
);
	logic [WIDTH-1:0] digit0, digit1;
	logic             digit0IsEqual, digit1IsEqual;
	
	// Turn off seven-segment displays
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	// Last two digits of my student ID number: 97
	assign digit1 = 9;
	assign digit0 = 7;

	assign LEDR[0] = digit0IsEqual && digit1IsEqual;

	signal_equality_checker #(.WIDTH(WIDTH)) digit0Comp(.equal(digit0IsEqual), .signal0(SW[3:0]), .signal1(digit0));
	signal_equality_checker #(.WIDTH(WIDTH)) digit1Comp(.equal(digit1IsEqual), .signal0(SW[7:4]), .signal1(digit1));
endmodule

module DE1_SoC_testbench();
	parameter WIDTH = 4;

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	DE1_SoC #(.WIDTH(WIDTH)) dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	integer i;
	initial begin
		for (i = 0; i < 2 ** (WIDTH * 2); i++) begin
			SW[(WIDTH * 2 - 1):0] = i; #10;
		end
	end
endmodule