/**
 * DE1_SoC.sv
 *
 * This module defines the I/Os for the DE-1 SoC board and connects the stolen detector module to the hardware.
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
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
	stolen_detector detector(.isStolen(LEDR[0]), .isDiscounted(LEDR[1]), .u(SW[9]), .p(SW[8]), .c(SW[7]), .isMarkPresent(SW[0]));
endmodule



module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	/**
	 * Test cases with expected outputs:
	 *
	 *  SW[9] | SW[8] | SW[7] | SW[0] || LEDR[1] | LEDR[0]
	 * -------|-------|-------|-------||---------|---------
	 *  0     | 0     | 0     | 0     || 0       |    1
	 *  0     | 0     | 0     | 1     || 0       |    0
	 *  0     | 0     | 1     | 0     || 0	     |    0
	 *  0     | 0     | 1     | 1     || 0       |    X
	 * -------|-------|-------|-------||---------|---------
	 *  0     | 1     | 0     | 0     || X	     |    X
	 *  0     | 1     | 0     | 1     || X       |    X
	 *  0     | 1     | 1     | 0     || 1       |    0
	 *  0     | 1     | 1     | 1     || 1       |    X
	 * -------|-------|-------|-------||---------|---------
	 *  1     | 0     | 0     | 0     || 0       |    1
	 *  1     | 0     | 0     | 1     || 0       |    0
	 *  1     | 0     | 1     | 0     || 1       |    1
	 *  1     | 0     | 1     | 1     || 1       |    0
	 * -------|-------|-------|-------||---------|---------
	 *  1     | 1     | 0     | 0     || 1       |    0
	 *  1     | 1     | 0     | 1     || 1       |    X
	 *  1     | 1     | 1     | 0     || X       |    X
	 *  1     | 1     | 1     | 1     || X       |    X
	 */

	typedef struct {
		logic [9:0] SW;
		logic [1:0] expected_LEDR;
	} test_case_t;

	test_case_t test_cases[2 ** 4] = '{
		'{10'b000xxxxxx0, 2'b01},
		'{10'b000xxxxxx1, 2'b00},
		'{10'b001xxxxxx0, 2'b00},
		'{10'b001xxxxxx1, 2'b0x},
		'{10'b010xxxxxx0, 2'bxx},
		'{10'b010xxxxxx1, 2'bxx},
		'{10'b011xxxxxx0, 2'b10},
		'{10'b011xxxxxx1, 2'b1x},
		'{10'b100xxxxxx0, 2'b01},
		'{10'b100xxxxxx1, 2'b00},
		'{10'b101xxxxxx0, 2'b11},
		'{10'b101xxxxxx1, 2'b10},
		'{10'b110xxxxxx0, 2'b10},
		'{10'b110xxxxxx1, 2'b1x},
		'{10'b111xxxxxx0, 2'bxx},
		'{10'b111xxxxxx1, 2'bxx}
	};
	
	int i;
	int failure_count = 0;
	initial begin
		for (i = 0; i < 2 ** 4; i++) begin
			SW[9:7] = test_cases[i].SW[9:7];
			SW[0] = test_cases[i].SW[0];
			
			#10;

			assert (LEDR[1:0] ==? test_cases[i].expected_LEDR) else begin
				failure_count++;
				$error("Test case %0d failed.\nInputs: SW[9:7]=%b, SW[0]=%b\nExpected outputs: LEDR[1:0]=%b\nActual outputs: LEDR[1:0]=%b",
					i,
					test_cases[i].SW[9:7], test_cases[i].SW[0],
					test_cases[i].expected_LEDR,
					LEDR[1:0]
				);
			end
		end

		$display("Testbench completed. Failures: %0d", failure_count);
	end
endmodule