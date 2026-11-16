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
	logic KEY0_sync;
	synchronizer #(.WIDTH(1)) sync_KEY0 (.clk, .async_in(KEY[0]), .sync_out(KEY0_sync));
	assign reset = ~KEY0_sync;

	// synchronize switch inputs
	logic [9:0] SW_sync;
	synchronizer #(.WIDTH(10)) sync_SW (.clk, .async_in(SW), .sync_out(SW_sync));

	logic       start;
	logic [7:0] a;
	logic [3:0] count;
	logic       done;

	assign start = SW_sync[9];
	assign a = SW_sync[7:0];
	assign LEDR[9] = done;

	bit_counter #(.WIDTH(8)) counter(.clk, .reset, .start, .a, .count, .done);

	logic [6:0] count_display;
	seg7 seg7_count (.digit(count), .leds(count_display));

	always_comb begin
		if (done)
			HEX0 = count_display;
		else
			HEX0 = '1;	
	end

	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	assign LEDR[8:0] = '0;
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
		int failureCount = 0;

		KEY <= 4'b1111;
		SW <= 10'b0;

		@(posedge CLOCK_50);

		// reset
		KEY[0] <= 1'b0;
		@(posedge CLOCK_50);
		KEY[0] <= 1'b1;
		@(posedge CLOCK_50);

		for (i = 0; i < 256; i++) begin
			SW[7:0] <= i;
			repeat(2) @(posedge CLOCK_50);

			SW[9] <= 1;

			repeat(15) @(posedge CLOCK_50);

			assert(dut.done == 1) else begin
				$error("Computation did not finish in time.");
				failureCount++;
			end

			SW[9] <= 0;
			repeat(2) @(posedge CLOCK_50);
		end

		$display("%0d tests failed.", failureCount);
		$stop;
	end
endmodule