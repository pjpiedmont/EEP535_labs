/**
 * 7-segment display decoder
 *
 * This module takes a 4-bit binary input and outputs the corresponding 7-bit pattern to drive a 7-segment display.
 *
 * Inputs:
 * - digit: 4-bit binary input representing a hexadecimal digit.
 *
 * Outputs:
 * - leds: 7-bit output representing the segments of the 7-segment display.
 */
module seg7(
	input  logic[3:0] digit,
	output logic[6:0] leds
);
	always_comb begin
		case (digit)
			//       light: gfedcba
			4'h0: leds = 7'b1000000;
			4'h1: leds = 7'b1111001;
			4'h2: leds = 7'b0100100;
			4'h3: leds = 7'b0110000;
			4'h4: leds = 7'b0011001;
			4'h5: leds = 7'b0010010;
			4'h6: leds = 7'b0000010;
			4'h7: leds = 7'b1111000;
			4'h8: leds = 7'b0000000;
			4'h9: leds = 7'b0010000;

			// Initially I added support for hexadecimal digits, but the lab used only decimal digits, and I wanted to see
			// what happens when the LEDs are driven by a don't care
			/*
			4'ha: leds = 7'b0001000;
			4'hb: leds = 7'b0000011;
			4'hc: leds = 7'b1000110;
			4'hd: leds = 7'b0100001;
			4'he: leds = 7'b0000110;
			4'hf: leds = 7'b0001110;
			*/

			default: leds = 7'bx;
		endcase
	end
endmodule



module seg7_testbench();
	logic[3:0] digit;
	logic[6:0] leds;
	
	seg7 dut(.digit, .leds);

	typedef struct {
		logic[3:0] digit;
		logic[6:0] expected_leds;
	} test_case_t;

	localparam int NUM_TEST_CASES = 10;

	test_case_t test_cases[NUM_TEST_CASES] = '{
		'{4'h0, 7'b1000000},
		'{4'h1, 7'b1111001},
		'{4'h2, 7'b0100100},
		'{4'h3, 7'b0110000},
		'{4'h4, 7'b0011001},
		'{4'h5, 7'b0010010},
		'{4'h6, 7'b0000010},
		'{4'h7, 7'b1111000},
		'{4'h8, 7'b0000000},
		'{4'h9, 7'b0010000}
	};

	integer i;
	integer failure_count = 0;
	initial begin
		for (i = 0; i < NUM_TEST_CASES; i++) begin
			digit = test_cases[i].digit;
			
			#10;

			assert (leds ==? test_cases[i].expected_leds) else begin
				$display("Test failed for digit %0d: expected %b, got %b", digit, test_cases[i].expected_leds, leds);
				failure_count++;
			end
		end

		$display("Testbench completed. Failures: %0d", failure_count);
	end
endmodule