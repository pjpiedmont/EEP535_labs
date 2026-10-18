/**
 * stolen_detector.sv
 *
 * This module detects whether an item is stolen or discounted according to the table provided in the lab instructions.
 *
 * Inputs:
 * - u: Digit 2 of the UPC.
 * - p: Digit 1 of the UPC.
 * - c: Digit 0 of the UPC.
 * - isMarkPresent: Indicates if the secret mark is present on the item.
 *
 * Outputs:
 * - isStolen: High if the item is stolen.
 * - isDiscounted: High if the item was discounted.
 */
module stolen_detector(isStolen, isDiscounted, u, p, c, isMarkPresent);
	output logic isStolen;
	output logic isDiscounted;
	input  logic u;
	input  logic p;
	input  logic c;
	input  logic isMarkPresent;
	
	assign isStolen = ~(p | isMarkPresent | (~u & c));
	assign isDiscounted = (p | (u & c));
endmodule

module stolen_detector_testbench();
	logic isStolen;
	logic isDiscounted;
	logic u;
	logic p;
	logic c;
	logic isMarkPresent;
	
	stolen_detector dut(.isStolen, .isDiscounted, .u, .p, .c, .isMarkPresent);
	
	int i;
	initial begin
		for (i = 0; i < 2 ** 4; i++) begin
			{ u, p, c, isMarkPresent } = i; #10;
		end
	end
endmodule