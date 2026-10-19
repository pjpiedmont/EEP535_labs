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

	localparam BASE = 10;
	localparam int NUM_TEST_CASES = BASE ** 2;

	// Create a lookup table for the 7-segment display so I can programmatically generate the test cases
	logic [6:0] seg7_lookup[10] = '{
		7'b1000000, // 0
		7'b1111001, // 1
		7'b0100100, // 2
		7'b0110000, // 3
		7'b0011001, // 4
		7'b0010010, // 5
		7'b0000010, // 6
		7'b1111000, // 7
		7'b0000000, // 8
		7'b0010000  // 9
	};

	typedef struct {
		logic [7:0] SW;
		logic [6:0] expected_HEX0;
		logic [6:0] expected_HEX1;
	} test_case_t;

	test_case_t test_cases[NUM_TEST_CASES];
	
	int digit0, digit1;
	int i, index;
	int failure_count = 0;
	
	initial begin
		// Generate test cases
		for (digit1 = 0; digit1 < BASE; digit1++) begin
			for (digit0 = 0; digit0 < BASE; digit0++) begin
				index = (digit1 * BASE) + digit0;

				test_cases[index].SW = {digit1[3:0], digit0[3:0]};
				test_cases[index].expected_HEX0 = seg7_lookup[digit0];
				test_cases[index].expected_HEX1 = seg7_lookup[digit1];
			end
		end

		// Verify test cases
		for (i = 0; i < NUM_TEST_CASES; i++) begin
			SW[7:0] = test_cases[i].SW;
			
			#10;

			assert (HEX0 === test_cases[i].expected_HEX0 && HEX1 === test_cases[i].expected_HEX1) else begin
				failure_count++;
				$error("Test case %0d failed\nInputs: SW[7:4]=%b, SW[3:0]=%b\nExpected outputs: HEX0=%b, HEX1=%b\n Actual outputs: HEX0=%b, HEX1=%b",
					i,
					test_cases[i].SW[7:4], test_cases[i].SW[3:0],
					test_cases[i].expected_HEX0, test_cases[i].expected_HEX1,
					HEX0, HEX1
				);
			end
		end

		$display("Testbench completed. Failures: %0d", failure_count);
	end
endmodule