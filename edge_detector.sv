module edge_detector #(
	parameter bit DETECT_RISING_EDGE = 1'b1,
	parameter bit DETECT_FALLING_EDGE = 1'b0
)(
	input  logic clk,
	input  logic reset,
	input  logic in,
	output logic out
);
	typedef enum logic { OFF, ON } state_t;
	state_t ps, ns;

	// output logic - Mealy machine
	always_comb begin
		unique case ({ ps, in })
			{ OFF, 1'b0 }: out = 1'b0;
			{ OFF, 1'b1 }: out = 1'b1;
			{ ON,  1'b0 }: out = 1'b0;
			{ ON,  1'b1 }: out = 1'b0;
		endcase
	end

	// next state logic
	always_comb begin
		unique case ({ ps, in })
			{ OFF, 1'b0 }: ns = OFF;
			{ OFF, 1'b1 }: ns = ON;
			{ ON,  1'b0 }: ns = OFF;
			{ ON,  1'b1 }: ns = ON;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= OFF;
		else
			ps <= ns;
	end
endmodule



module edge_detector_testbench();
	logic clk, reset, in, out;

	edge_detector dut(.clk, .reset, .in, .out);

	parameter CLOCK_PERIOD = 100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
			@(posedge clk);
		reset <= 1; in <= 0; @(posedge clk);
			@(posedge clk);
		
		// test pulsing the button
		in <= 1; @(posedge clk);
		in <= 0; @(posedge clk);

		// test holding the button
		in <= 1; repeat(5) @(posedge clk);
		in <= 0; @(posedge clk);
	end
endmodule