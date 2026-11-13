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

	logic [$clog2(DEPTH)-1:0] address;
	logic [WIDTH-1:0]         dataIn;
	logic                     writeEnable;
	logic                     clk;
	logic [WIDTH-1:0]         dataOut;

	ram #(.WIDTH, .DEPTH) dut(.address, .dataIn, .writeEnable, .clk, .dataOut);

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		@(posedge clk);
		writeEnable <= 1;
		
		int i;

		// write to each RAM address
		for (i = 0; i < DEPTH; i++) begin
			address <= i;
			dataIn <= i;
			@(posedge clk);
		end

		// read from each RAM address and check the value
		for (i = 0; i < DEPTH; i++) begin
			address <= i;
			@(posedge clk);
			assert(dataOut == i) else $fatal("Data mismatch at address %0d: expected %0d, got %0d", i, i, dataOut);
		end
	end
endmodule