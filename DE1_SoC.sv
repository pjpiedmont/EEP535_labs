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
	parameter WIDTH = 4,
	// Last two digits of my student ID number: 97
	parameter DIGIT0 = 7,
	parameter DIGIT1 = 9
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

	assign digit0 = DIGIT0[WIDTH-1:0];
	assign digit1 = DIGIT1[WIDTH-1:0];

	assign LEDR[0] = digit0IsEqual && digit1IsEqual;

	signal_equality_checker #(.WIDTH(WIDTH)) digit0Comp(.equal(digit0IsEqual), .signal0(SW[3:0]), .signal1(digit0));
	signal_equality_checker #(.WIDTH(WIDTH)) digit1Comp(.equal(digit1IsEqual), .signal0(SW[7:4]), .signal1(digit1));
endmodule



module DE1_SoC_testbench();
	localparam WIDTH = 4;
	localparam DIGIT0 = 7;
	localparam DIGIT1 = 9;

	localparam TOTAL_TEST_CASES = 2 ** (WIDTH * 2);

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	DE1_SoC #(.WIDTH(WIDTH), .DIGIT0(DIGIT0), .DIGIT1(DIGIT1)) dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	typedef struct {
		logic [WIDTH-1:0] switch_set0;
		logic [WIDTH-1:0] switch_set1;
		logic             expected_led;
	} test_case_t;

	test_case_t test_cases[TOTAL_TEST_CASES];

	integer i;
	integer failure_count = 0;
	initial begin
		for (i = 0; i < TOTAL_TEST_CASES; i++) begin
			{ test_cases[i].switch_set1, test_cases[i].switch_set0 } = i;
			test_cases[i].expected_led = ((test_cases[i].switch_set0 == DIGIT0) && (test_cases[i].switch_set1 == DIGIT1));
		end

		for (i = 0; i < TOTAL_TEST_CASES; i++) begin
			SW[((WIDTH * 2) - 1):WIDTH] = test_cases[i].switch_set1;
			SW[(WIDTH - 1):0] = test_cases[i].switch_set0;

			#10;

			assert (LEDR[0] === test_cases[i].expected_led) else begin
				failure_count++;
				$error("Test case %0d failed: switch_set0=%b, switch_set1=%b, expected_led=%b, actual_led=%b",
					i, test_cases[i].switch_set0, test_cases[i].switch_set1, test_cases[i].expected_led, LEDR[0]);
			end
		end

		$display("Testbench completed. Failures: %0d", failure_count);
	end
endmodule