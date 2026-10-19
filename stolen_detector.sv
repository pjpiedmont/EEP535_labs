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

	/**
	 * Test cases with expected outputs:
	 *
	 *  u | p | c | isMarkPresent || isStolen | isDiscounted
	 * ---|---|---|---------------||----------|-------------
	 *  0 | 0 | 0 | 0             ||    1     |      0
	 *  0 | 0 | 0 | 1             ||    0 	  |      0
	 *  0 | 0 | 1 | 0             ||    0     |      0
	 *  0 | 0 | 1 | 1             ||    X     |      0
	 * ---|---|---|---------------||----------|-------------
	 *  0 | 1 | 0 | 0             ||    X	  |      X
	 *  0 | 1 | 0 | 1             ||    X     |      X
	 *  0 | 1 | 1 | 0             ||    0	  |      1
	 *  0 | 1 | 1 | 1             ||    X     |      1
	 * ---|---|---|---------------||----------|-------------
	 *  1 | 0 | 0 | 0             ||    1	  |      0
	 *  1 | 0 | 0 | 1             ||    0     |      0
	 *  1 | 0 | 1 | 0             ||    1     |      1
	 *  1 | 0 | 1 | 1             ||    0     |      1
	 * ---|---|---|---------------||----------|-------------
	 *  1 | 1 | 0 | 0             ||    0     |      1
	 *  1 | 1 | 0 | 1             ||    X	  |      1
	 *  1 | 1 | 1 | 0             ||    X     |      X
	 *  1 | 1 | 1 | 1             ||    X	  |      X
	 */

	typedef struct {
		logic u, p, c, isMarkPresent;
		logic expected_isStolen, expected_isDiscounted;
	} test_case_t;

	test_case_t test_cases[2 ** 4] = '{
		'{0, 0, 0, 0,  1,  0},
		'{0, 0, 0, 1,  0,  0},
		'{0, 0, 1, 0,  0,  0},
		'{0, 0, 1, 1, 'x,  0},
		'{0, 1, 0, 0, 'x, 'x},
		'{0, 1, 0, 1, 'x, 'x},
		'{0, 1, 1, 0,  0,  1},
		'{0, 1, 1, 1, 'x,  1},
		'{1, 0, 0, 0,  1,  0},
		'{1, 0, 0, 1,  0,  0},
		'{1, 0, 1, 0,  1,  1},
		'{1, 0, 1, 1,  0,  1},
		'{1, 1, 0, 0,  0,  1},
		'{1, 1, 0, 1, 'x,  1},
		'{1, 1, 1, 0, 'x, 'x},
		'{1, 1, 1, 1, 'x, 'x}
	};

	int i;
	int failure_count = 0;
	initial begin
		for (i = 0; i < 2 ** 4; i++) begin
			u = test_cases[i].u;
			p = test_cases[i].p;
			c = test_cases[i].c;
			isMarkPresent = test_cases[i].isMarkPresent;

			#10;

			assert (isStolen ==? test_cases[i].expected_isStolen && isDiscounted ==? test_cases[i].expected_isDiscounted) else begin
				failure_count++;
				$error("Test case %0d failed.\nInputs: u=%b, p=%b, c=%b, isMarkPresent=%b\nExpected outputs: isStolen=%b, isDiscounted=%b\nActual outputs: isStolen=%b, isDiscounted=%b",
					i,
					test_cases[i].u, test_cases[i].p, test_cases[i].c, test_cases[i].isMarkPresent,
					test_cases[i].expected_isStolen, test_cases[i].expected_isDiscounted,
					isStolen, isDiscounted
				);
			end
		end

		$display("Testbench completed. Failures: %0d", failure_count);
	end
endmodule