module synchronizer #(
    parameter WIDTH = 1
)(
	input  logic clk,
	input  logic [WIDTH - 1:0] async_in,
	output logic [WIDTH - 1:0] sync_out
);
	logic [WIDTH - 1:0] d1, d2;

	always_ff @(posedge clk) begin
        d1 <= async_in;
        d2 <= d1;
	end

	assign sync_out = d2;
endmodule