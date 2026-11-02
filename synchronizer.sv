module synchronizer(
	input  logic clk,
	input  logic reset,
	input  logic async_in,
	output logic sync_out
);
	logic d1, d2;

	// DFFs
	always_ff @(posedge clk) begin
		if (reset) begin
			d1 <= 1'b0;
			d2 <= 1'b0;
		end else begin
			d1 <= async_in;
			d2 <= d1;
		end
	end

	assign sync_out = d2;
endmodule