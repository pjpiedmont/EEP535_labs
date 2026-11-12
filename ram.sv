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