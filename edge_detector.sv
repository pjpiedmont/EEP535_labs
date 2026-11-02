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



module edge_detector_testbench();
	logic clk, reset, button, pulse;

	edge_detector dut(.clk, .reset, .button, .pulse);

	parameter CLOCK_PERIOD = 100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
			@(posedge clk);
		reset <= 1; button <= 0; @(posedge clk);
			@(posedge clk);
		
		// test pulsing the button
		button <= 1; @(posedge clk);
		button <= 0; @(posedge clk);

		// test holding the button
		button <= 1; repeat(5) @(posedge clk);
		button <= 0; @(posedge clk);
	end
endmodule