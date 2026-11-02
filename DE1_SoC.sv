// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC(
	input  logic       CLOCK_50, // 50MHz clock.
	input  logic [3:0] KEY,  // active low
	input  logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic reset;
	logic [31:0] div_clk;

	assign reset = SW[9];
	
	parameter whichClock = 25; // 0.75 Hz clock
	clock_divider cdiv (.clock(CLOCK_50), .reset, .divided_clocks(div_clk));

	// Clock selection; allows for easy switching between simulation and board clocks
	logic clkSelect;
	
	// Uncomment ONE of the following two lines depending on intention
	assign clkSelect = CLOCK_50; // for simulation
	//assign clkSelect = div_clk[whichClock]; // for board
	
	wind_directions_pkg::wind_directions_e wind;
	assign wind = wind_directions_pkg::wind_directions_e'(SW[1:0]);

	hazard_lights dut (.clk(clkSelect), .reset, .wind, .lights(LEDR[2:0]));
endmodule



module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	DE1_SoC dut(.CLOCK_50, .KEY, .SW, .LEDR, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end

	// Test the design.
	initial begin
			@(posedge CLOCK_50);

		// test calm wind
		SW[9] <= 1; SW[1:0] <= 0; @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
			repeat(3) @(posedge CLOCK_50);

		// test right to left wind
		SW[9] <= 0; SW[1:0] <= 2'b01; @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
			repeat(3) @(posedge CLOCK_50);

		// test left to right wind
		SW[9] <= 0; SW[1:0] <= 2'b10; @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
			repeat(3) @(posedge CLOCK_50);
		
		// test changing direction in middle of pattern
			repeat(2) @(posedge CLOCK_50);
		SW[1:0] <= 2'b01; @(posedge CLOCK_50);
			repeat(3) @(posedge CLOCK_50);	
		
		$stop; // End the simulation.
	end
endmodule
