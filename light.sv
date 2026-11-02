module light(
	input  logic clk,
	input  logic reset,
	input  logic leftNeighbor,
	input  logic rightNeighbor,
	input  logic buttonPlayer1,
	input  logic buttonPlayer2,
	input  logic isCenterLight,
	output logic lightOn
);
	light_states_pkg::light_states_e ps, ns;

	// next state logic
	always_comb begin
		unique case ({ ps, leftNeighbor, rightNeighbor, buttonPlayer1, buttonPlayer2 })
			{ light_states_pkg::OFF, 1'b1, *, *, 1'b1 }: ns = light_states_pkg::ON;
			{ light_states_pkg::OFF, *, 1'b1, 1'b1, * }: ns = light_states_pkg::ON;
			{ light_states_pkg::OFF, *, *, 1'b0, 1'b0 }: ns = light_states_pkg::OFF;
			{ light_states_pkg::ON, *, *, 1'b1, * }:     ns = light_states_pkg::OFF;
			{ light_states_pkg::ON, *, *, *, 1'b1 }:     ns = light_states_pkg::OFF;
			{ light_states_pkg::ON, *, *, 1'b0, 1'b0 }:  ns = light_states_pkg::ON;
		endcase
	end

	// output logic
	always_comb begin
		case (ps)
			light_states_pkg::OFF: lightOn = 1'b0;
			light_states_pkg::ON:  lightOn = 1'b1;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset) begin
			if (isCenterLight)
				ps <= light_states_pkg::ON;
			else
				ps <= light_states_pkg::OFF;
		end
		else begin
			ps <= ns;
		end
	end
endmodule