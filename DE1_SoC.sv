module DE1_SoC(
	input  logic       CLOCK_50,
	input  logic [3:0] KEY,
	input  logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	localparam COUNTER_MAX = 32;

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

	// convert KEY0 input to a single-cycle pulse
	logic KEY0_edge;
	edge_detector #(.DETECT_RISING_EDGE(1'b0), .DETECT_FALLING_EDGE(1'b1)) edge0 (.clk, .reset, .in(KEY0_sync), .out(KEY0_edge));

	// signals for RAM
	logic       write_en;
	logic [4:0] read_addr, write_addr;
	logic [3:0] data_out, data_in;

	// set up counter for read address
	logic counter_enable;
	assign counter_enable = KEY0_edge;
	counter #(.MAX_COUNT(COUNTER_MAX)) counter0 (.clk, .reset, .enable(counter_enable), .count(read_addr));

	assign write_en = SW_sync[9];
	assign write_addr = SW_sync[8:4];
	assign data_in = SW_sync[3:0];

	ram32x4port2 ram (.clock(clk), .data(data_in), .rdaddress(read_addr), .wraddress(write_addr), .wren(write_en), .q(data_out));

	// split addresses into two 4-bit values for display
	logic [3:0] read_addr_high, read_addr_low, write_addr_high, write_addr_low;
	assign read_addr_high = {{3{1'b0}}, read_addr[4]};
	assign read_addr_low = read_addr[3:0];
	assign write_addr_high = {{3{1'b0}}, write_addr[4]};
	assign write_addr_low = write_addr[3:0];

	// convert address nibbles to 7-segment display
	logic [6:0] read_addr_high_display, read_addr_low_display, write_addr_high_display, write_addr_low_display;
	seg7 seg7_read_addr_high (.digit(read_addr_high), .leds(read_addr_high_display));
	seg7 seg7_read_addr_low (.digit(read_addr_low), .leds(read_addr_low_display));
	seg7 seg7_write_addr_high (.digit(write_addr_high), .leds(write_addr_high_display));
	seg7 seg7_write_addr_low (.digit(write_addr_low), .leds(write_addr_low_display));

	// display the address nibbles
	assign HEX5 = write_addr_high_display;
	assign HEX4 = write_addr_low_display;
	assign HEX3 = read_addr_high_display;
	assign HEX2 = read_addr_low_display;

	// convert data to 7-segment display
	logic [6:0] data_out_display, data_in_display;
	seg7 seg7_data_out (.digit(data_out), .leds(data_out_display));
	seg7 seg7_data_in (.digit(data_in), .leds(data_in_display));
	assign HEX1 = data_in_display;
	assign HEX0 = data_out_display;

	assign LEDR = 10'b0;
endmodule



`timescale 1 ps / 1 ps
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
		int temp;
		int failureCount = 0;

		KEY <= 4'b1111;
		SW <= 10'b0;

		@(posedge CLOCK_50);

		// reset
		KEY[3] <= 1'b0;
		@(posedge CLOCK_50);
		KEY[3] <= 1'b1;
		@(posedge CLOCK_50);

		// verify pre-initialized data in RAM
		for (i = 0; i < 32; i++) begin
			KEY[0] <= 1'b0;
			repeat(3) @(posedge CLOCK_50);

			assert(dut.data_out == i[3:0]) else begin
				$error("Got wrong value from RAM. Expected %0d, got %0d.", i[3:0], dut.data_out);
				failureCount++;
			end

			KEY[0] <= 1'b1;
			repeat(3) @(posedge CLOCK_50);
		end

		// overwrite RAM
		for (i = 0; i < 32; i++) begin
			temp = 32 - i - 1;	

			SW[8:4] <= i;
			SW[3:0] <= temp[3:0];

			repeat(3) @(posedge CLOCK_50);
			SW[9] <= 1'b1;

			repeat(3) @(posedge CLOCK_50);
			SW[9] <= 1'b0;
		end

		// check new RAM values
		for (i = 0; i < 32; i++) begin
			temp = 32 - i - 1;

			KEY[0] <= 1'b0;
			repeat(3) @(posedge CLOCK_50);

			assert(dut.data_out == temp[3:0]) else begin
				$error("Got wrong value from RAM. Expected %0d, got %0d.", temp[3:0], dut.data_out);
				failureCount++;
			end

			KEY[0] <= 1'b1;
			repeat(3) @(posedge CLOCK_50);
		end

		$display("%0d tests failed.", failureCount);
		$stop;
	end
endmodule
