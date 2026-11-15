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
	logic KEY3_sync, KEY0_sync;
	synchronizer #(.WIDTH(1)) sync_KEY3 (.clk, .async_in(KEY[3]), .sync_out(KEY3_sync));
	synchronizer #(.WIDTH(1)) sync_KEY0 (.clk, .async_in(KEY[0]), .sync_out(KEY0_sync));

	assign reset = ~KEY3_sync;

	// synchronize switch inputs
	logic [9:0] SW_sync;
	synchronizer #(.WIDTH(10)) sync_SW (.clk, .async_in(SW), .sync_out(SW_sync));

	logic       write_en;
	logic [4:0] write_addr;
	logic [3:0] write_data;

	assign write_en = SW_sync[9];
	assign write_addr = SW_sync[8:4];
	assign write_data = SW_sync[3:0];

	// convert KEY0 input to a single-cycle pulse
	logic KEY0_edge;
	edge_detector #(.DETECT_RISING_EDGE(1'b0), .DETECT_FALLING_EDGE(1'b1)) edge0 (.clk, .reset, .in(KEY0_sync), .out(KEY0_edge));

	localparam COUNTER_MAX = 32;
	localparam COUNTER_WIDTH = $clog2(COUNTER_MAX);

	// set up counter for read address
	logic counter_enable;
	logic [COUNTER_WIDTH - 1:0] read_addr;
	assign counter_enable = KEY0_edge;
	counter #(.MAX_COUNT(COUNTER_MAX)) counter0 (.clk, .reset, .enable(counter_enable), .count(read_addr));

	// split write address into two 4-bit values for display
	logic [3:0] write_addr_high, write_addr_low;
	assign write_addr_high = {{3{1'b0}}, write_addr[4]};
	assign write_addr_low = write_addr[3:0];

	// convert write address nibbles to 7-segment display
	logic [6:0] write_addr_high_display, write_addr_low_display;
	seg7 seg7_write_addr_high (.digit(write_addr_high), .leds(write_addr_high_display));
	seg7 seg7_write_addr_low (.digit(write_addr_low), .leds(write_addr_low_display));

	// display the write address nibbles
	assign HEX5 = write_addr_high_display;
	assign HEX4 = write_addr_low_display;

	// convert write data to 7-segment display
	logic [6:0] write_data_display;
	seg7 seg7_write_data (.digit(write_data), .leds(write_data_display));
	assign HEX1 = write_data_display;

	// split read address into two 4-bit values for display
	logic [3:0] read_addr_high, read_addr_low;
	assign read_addr_high = {{(8 - COUNTER_WIDTH){1'b0}}, read_addr[COUNTER_WIDTH - 1:4]};
	assign read_addr_low = read_addr[3:0];

	// convert read address nibbles to 7-segment display
	logic [6:0] read_addr_high_display, read_addr_low_display;
	seg7 seg7_read_addr_high (.digit(read_addr_high), .leds(read_addr_high_display));
	seg7 seg7_read_addr_low (.digit(read_addr_low), .leds(read_addr_low_display));

	// display the read address nibbles
	assign HEX3 = read_addr_high_display;
	assign HEX2 = read_addr_low_display;

	assign LEDR = 10'b0;

	assign HEX0 = 7'b1111111;

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
		int i;
// 		int failureCount = 0;

		KEY <= 4'b1111;
		SW <= 10'b0;

		@(posedge CLOCK_50);

		KEY[3] <= 0;
		@(posedge CLOCK_50);

		KEY[3] <= 1;
		@(posedge CLOCK_50);

		SW[9] = 1;

		// write to each RAM address
		for (i = 0; i < 32; i++) begin
			SW[8:4] <= i;
			SW[3:0] <= i[3:0];
			@(posedge CLOCK_50);
		end

		SW[9] <= 0;

		// cycle through read addresses
		for (i = 0; i < 32; i++) begin
			KEY[0] <= 0;
			repeat (2) @(posedge CLOCK_50);
			KEY[0] <= 1;
			repeat (2) @(posedge CLOCK_50);
		end

		// repeat (10) @(posedge CLOCK_50);

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
