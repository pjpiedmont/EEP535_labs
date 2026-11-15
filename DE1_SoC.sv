module DE1_SoC(
	input  logic [3:0] KEY,
	input  logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	// clock is manually controlled by pressing KEY[0]
	logic clk;
	assign clk = ~KEY[0];

	logic [4:0] address;
	logic [3:0] dataIn;
	logic [3:0] dataOut;

	assign address = SW[8:4];
	assign dataIn = SW[3:0];

	ram #(.WIDTH(4), .DEPTH(32)) ram0(
		.address,
		.dataIn,
		.writeEnable(SW[9]),
		.clk,
		.dataOut
	);

	// display address on HEX5 and HEX4
	seg7 seg7_addr_high(.digit({{3{1'b0}}, address[4]}), .leds(HEX5));
	seg7 seg7_addr_low(.digit(address[3:0]), .leds(HEX4));

	// display dataIn on HEX2
	seg7 seg7_dataIn(.digit(dataIn), .leds(HEX2));

	// display dataOut on HEX0
	seg7 seg7_dataOut(.digit(dataOut), .leds(HEX0));

	assign HEX3 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	
	assign LEDR = 10'b0;
endmodule



module DE1_SoC_testbench();
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	DE1_SoC dut(.KEY, .SW, .LEDR, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	initial begin
		int i;
		int failureCount = 0;

		KEY[0] = 1;
		SW[9] = 1;

		// write to each RAM address
		for (i = 0; i < 32; i++) begin
			SW[8:4] = i;
			SW[3:0] = i[3:0];

			#10;
			KEY[0] = 0;

			#10;
			KEY[0] = 1;
		end

		SW[9] = 0;

		// read from each RAM address
		for (i = 0; i < 32; i++) begin
			SW[8:4] = i;

			#10;
			KEY[0] = 0;

			#10;
			KEY[0] = 1;

			assert(dut.ram0.dataOut == i[3:0]) else begin
				$error("Data mismatch at address %0d: expected %0d, got %0d", i, i[3:0], dut.ram0.dataOut);
				failureCount++;
			end
		end

		$display("%0d of %0d tests failed.", failureCount, 32);
		$stop;
	end
endmodule
