module DE1_SoC(
	input  logic       CLOCK_50,
	input  logic [3:0] KEY,
	input  logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	logic clk, reset;
	assign clk = CLOCK_50;

	// synchronize button inputs
	logic KEY0_sync, KEY3_sync;
	synchronizer #(.WIDTH(1)) sync0 (.clk, .async_in(KEY[0]), .sync_out(KEY0_sync));
	synchronizer #(.WIDTH(1)) sync3 (.clk, .async_in(KEY[3]), .sync_out(KEY3_sync));

	// convert KEY0 input to a single-cycle pulse
	logic KEY0_edge;
	edge_detector #(.DETECT_RISING_EDGE(1'b0), .DETECT_FALLING_EDGE(1'b1)) edge0 (.clk, .reset, .in(KEY0_sync), .out(KEY0_edge));

	assign reset = ~KEY3_sync;

	localparam COUNTER_MAX = 32;
	localparam COUNTER_WIDTH = $clog2(COUNTER_MAX);

	// set up counter
	logic counter_enable;
	logic [COUNTER_WIDTH - 1:0] count;
	assign counter_enable = KEY0_edge;
	counter #(.MAX_COUNT(COUNTER_MAX)) counter0 (.clk, .reset, .enable(counter_enable), .count);

	// split count into two 4-bit values for display
	logic [3:0] count_high, count_low;
	assign count_high = {{(8 - COUNTER_WIDTH){1'b0}}, count[COUNTER_WIDTH - 1:4]};
	assign count_low = count[3:0];

	// convert count nibbles to 7-segment display
	logic [6:0] count_high_display, count_low_display;
	seg7 seg7_high (.digit(count_high), .leds(count_high_display));
	seg7 seg7_low (.digit(count_low), .leds(count_low_display));

	// display the count nibbles
	always_comb begin
		if (reset) begin
			HEX3 = 7'b1111111;
			HEX2 = 7'b1111111;
		end else begin
			HEX3 = count_high_display;
			HEX2 = count_low_display;
		end
	end

	assign LEDR = 10'b0;

	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// logic [4:0] address;
	// logic [3:0] dataIn;
	// logic [3:0] dataOut;

	// assign address = SW[8:4];
	// assign dataIn = SW[3:0];

	// ram #(.WIDTH(4), .DEPTH(32)) ram0(
	// 	.address,
	// 	.dataIn,
	// 	.writeEnable(SW[9]),
	// 	.clk,
	// 	.dataOut
	// );

	// // display address on HEX5 and HEX4
	// seg7 seg7_addr_high(.digit({{3{1'b0}}, address[4]}), .leds(HEX5));
	// seg7 seg7_addr_low(.digit(address[3:0]), .leds(HEX4));

	// // display dataIn on HEX2
	// seg7 seg7_dataIn(.digit(dataIn), .leds(HEX2));

	// // display dataOut on HEX0
	// seg7 seg7_dataOut(.digit(dataOut), .leds(HEX0));

	// assign HEX3 = 7'b1111111;
	// assign HEX1 = 7'b1111111;
	
	// assign LEDR = 10'b0;
endmodule



module DE1_SoC_tb();
	localparam CLOCK_PERIOD = 100;

	logic       CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	DE1_SoC dut(.CLOCK_50, .KEY, .SW, .LEDR, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end

	initial begin
		KEY <= 4'b1111;
		SW <= 10'b0;

		@(posedge CLOCK_50);

		KEY[3] <= 0;
		repeat (2) @(posedge CLOCK_50);

		KEY[3] <= 1;
		@(posedge CLOCK_50);

		repeat (10) @(posedge CLOCK_50);

// 		int i;
// 		int failureCount = 0;

// 		KEY[0] = 1;
// 		SW[9] = 1;

// 		// write to each RAM address
// 		for (i = 0; i < 32; i++) begin
// 			SW[8:4] = i;
// 			SW[3:0] = i[3:0];

// 			#10;
// 			KEY[0] = 0;

// 			#10;
// 			KEY[0] = 1;
// 		end

// 		SW[9] = 0;

// 		// read from each RAM address
// 		for (i = 0; i < 32; i++) begin
// 			SW[8:4] = i;

// 			#10;
// 			KEY[0] = 0;

// 			#10;
// 			KEY[0] = 1;

// 			assert(dut.ram0.dataOut == i[3:0]) else begin
// 				$error("Data mismatch at address %0d: expected %0d, got %0d", i, i[3:0], dut.ram0.dataOut);
// 				failureCount++;
// 			end
// 		end

// 		$display("%0d of %0d tests failed.", failureCount, 32);
		$stop;
	end
endmodule
