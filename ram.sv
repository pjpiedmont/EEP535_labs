module ram #(
	parameter WIDTH = 4,
	parameter DEPTH = 32
)(
	input  logic [$clog2(DEPTH)-1:0] address,
	input  logic [WIDTH-1:0]         dataIn,
	input  logic                     writeEnable,
	input  logic                     clk,
	output logic [WIDTH-1:0]         dataOut
);
	logic [WIDTH-1:0] memory [DEPTH-1:0];

	logic [$clog2(DEPTH)-1:0] addressRegister;
	logic [WIDTH-1:0]         dataInRegister;
	logic                     writeEnableRegister;

	always_ff @(posedge clk) begin
		addressRegister <= address;
		dataInRegister <= dataIn;
		writeEnableRegister <= writeEnable;
	end

	assign dataOut = memory[addressRegister];

	always_comb begin
		if (writeEnableRegister > 0)
			memory[addressRegister] = dataInRegister;
	end
endmodule


module ram_tb();
	localparam WIDTH = 4;
	localparam DEPTH = 32;
	localparam CLOCK_PERIOD = 100;

	logic [$clog2(DEPTH)-1:0] address;
	logic [WIDTH-1:0]         dataIn;
	logic                     writeEnable;
	logic                     clk;
	logic [WIDTH-1:0]         dataOut;

	ram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut(.address, .dataIn, .writeEnable, .clk, .dataOut);

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		int i;
		int failureCount = 0;
		
		@(posedge clk);
		writeEnable <= 1;

		// write to each RAM address
		for (i = 0; i < DEPTH; i++) begin
			address <= i;
			dataIn <= i[WIDTH-1:0];
			@(posedge clk);
		end

		writeEnable <= 0;

		// read from each RAM address and check the value
		for (i = 0; i < DEPTH; i++) begin
			address <= i;
			@(posedge clk);
			#1;

			assert(dataOut == i[WIDTH-1:0]) else begin
				$error("Data mismatch at address %0d: expected %0d, got %0d", i, i[WIDTH-1:0], dataOut);
				failureCount++;
			end
		end

		$display("%0d of %0d tests failed.", failureCount, DEPTH);
		$stop;
	end
endmodule