module edge_detector(
	input  logic clk,
	input  logic reset,
	input  logic button,
	output logic pulse
);
	button_states_pkg::button_states_e ps, ns;

	// output logic
	always_comb begin
		unique case ({ ps, button })
			{ button_states_pkg::OFF, 1'b0 }: pulse = 1'b0;
			{ button_states_pkg::OFF, 1'b1 }: pulse = 1'b1;
			{ button_states_pkg::ON,  1'b0 }: pulse = 1'b0;
			{ button_states_pkg::ON,  1'b1 }: pulse = 1'b0;
		endcase
	end

	// next state logic
	always_comb begin
		unique case ({ ps, button })
			{ button_states_pkg::OFF, 1'b0 }: ns = button_states_pkg::OFF;
			{ button_states_pkg::OFF, 1'b1 }: ns = button_states_pkg::ON;
			{ button_states_pkg::ON,  1'b0 }: ns = button_states_pkg::OFF;
			{ button_states_pkg::ON,  1'b1 }: ns = button_states_pkg::ON;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= button_states_pkg::OFF;
		else
			ps <= ns;
	end
endmodule