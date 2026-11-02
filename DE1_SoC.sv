// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC(
	input  logic       CLOCK_50,  // 50MHz clock
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

	logic KEY0_sync, KEY3_sync;
	synchronizer sync1(.clk(clkSelect), .reset, .async_in(KEY[3]), .sync_out(KEY3_sync));
	synchronizer sync2(.clk(clkSelect), .reset, .async_in(KEY[0]), .sync_out(KEY0_sync));

	logic buttonPlayer1, buttonPlayer2;
	edge_detector ed1(.clk(clkSelect), .reset, .button(~KEY3_sync), .pulse(buttonPlayer1));
	edge_detector ed2(.clk(clkSelect), .reset, .button(~KEY0_sync), .pulse(buttonPlayer2));

	logic led1, led2, led3, led4, led5, led6, led7, led8, led9;
	light light1(.clk(clkSelect), .reset, .leftNeighbor(led2), .rightNeighbor(1'b0), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led1));
	light light2(.clk(clkSelect), .reset, .leftNeighbor(led3), .rightNeighbor(led1), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led2));
	light light3(.clk(clkSelect), .reset, .leftNeighbor(led4), .rightNeighbor(led2), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led3));
	light light4(.clk(clkSelect), .reset, .leftNeighbor(led5), .rightNeighbor(led3), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led4));
	light light5(.clk(clkSelect), .reset, .leftNeighbor(led6), .rightNeighbor(led4), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b1), .lightOn(led5));
	light light6(.clk(clkSelect), .reset, .leftNeighbor(led7), .rightNeighbor(led5), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led6));
	light light7(.clk(clkSelect), .reset, .leftNeighbor(led8), .rightNeighbor(led6), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led7));
	light light8(.clk(clkSelect), .reset, .leftNeighbor(led9), .rightNeighbor(led7), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led8));
	light light9(.clk(clkSelect), .reset, .leftNeighbor(1'b0), .rightNeighbor(led8), .buttonPlayer1, .buttonPlayer2, .isCenterLight(1'b0), .lightOn(led9));

	logic player1Wins, player2Wins;
	play_field pf(.clk(clkSelect), .reset, .leftLight(led9), .rightLight(led1), .buttonPlayer1, .buttonPlayer2, .player1Wins, .player2Wins);

	assign LEDR[1] = led1;
	assign LEDR[2] = led2;
	assign LEDR[3] = led3;
	assign LEDR[4] = led4;
	assign LEDR[5] = led5;
	assign LEDR[6] = led6;
	assign LEDR[7] = led7;
	assign LEDR[8] = led8;
	assign LEDR[9] = led9;

	always_comb begin
		if (player1Wins)
			HEX0 = 7'b1111001;
		else if (player2Wins)
			HEX0 = 7'b0100100;
		else
			HEX0 = 7'b1111111;
	end

	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
endmodule



module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 0;
		
		// Forever toggle the clock
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end

	// Test the design.
	initial begin
		repeat(1) @(posedge CLOCK_50);
		
		// Always reset FSMs at start
		SW[9] <= 1; repeat(1) @(posedge CLOCK_50);
		
		// Test case 1: input is 0
		SW[9] <= 0; repeat(1) @(posedge CLOCK_50);
		SW[0] <= 0; repeat(4) @(posedge CLOCK_50);
		
		// Test case 2: input 1 for 1 cycle
		SW[0] <= 1; repeat(1) @(posedge CLOCK_50);
		SW[0] <= 0; repeat(1) @(posedge CLOCK_50);
		
		// Test case 3: input 1 for >2 cycles
		SW[0] <= 1; repeat(4) @(posedge CLOCK_50);
		SW[0] <= 0; repeat(2) @(posedge CLOCK_50);
		
		$stop; // End the simulation.
	end
endmodule
