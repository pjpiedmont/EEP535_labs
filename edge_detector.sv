module edge_detector #(
	parameter bit DETECT_RISING_EDGE = 1'b1,
	parameter bit DETECT_FALLING_EDGE = 1'b0
)(
	input  logic clk,
	input  logic reset,
	input  logic in,
	output logic out
);
	typedef enum logic [1:0] { LOW, RISE, HIGH, FALL } state_t;
	state_t ps, ns;

	// output logic - Moore machine
	always_comb begin
		case (ps)
			RISE: out = DETECT_RISING_EDGE;
			FALL: out = DETECT_FALLING_EDGE;
            default: out = 1'b0;
		endcase
	end

	// next state logic
	always_comb begin
		unique case ({ ps, in })
			{ LOW, 1'b0 }:  ns = LOW;
			{ LOW, 1'b1 }:  ns = RISE;
			{ RISE, 1'b0 }: ns = FALL;
			{ RISE, 1'b1 }: ns = HIGH;
			{ HIGH, 1'b0 }: ns = FALL;
			{ HIGH, 1'b1 }: ns = HIGH;
			{ FALL, 1'b0 }: ns = LOW;
			{ FALL, 1'b1 }: ns = RISE;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= in ? HIGH : LOW;
		else
			ps <= ns;
	end
endmodule



module edge_detector_tb();
	localparam CLOCK_PERIOD = 100;

	logic clk, reset, in;
    logic out_rise, out_fall;

	edge_detector #(.DETECT_RISING_EDGE(1'b1), .DETECT_FALLING_EDGE(1'b0)) dut_rise(.clk, .reset, .in, .out(out_rise));
	edge_detector #(.DETECT_RISING_EDGE(1'b0), .DETECT_FALLING_EDGE(1'b1)) dut_fall(.clk, .reset, .in, .out(out_fall));

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
        in <= 0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		// test pulsing the input high
		in <= 1;
        #1;
        assert(out_rise == 0) else $error("Output went high too early on rising edge detection. Expected: 0, Got: %0d", out_rise);

        @(posedge clk);
        #1;
        assert(out_rise == 1) else $error("Output did not go high on rising edge detection. Expected: 1, Got: %0d", out_rise);

		in <= 0; repeat(2) @(posedge clk);

		// test holding the input high
		in <= 1;
        #1;
        assert(out_rise == 0) else $error("Output went high too early on rising edge detection. Expected: 0, Got: %0d", out_rise);

        @(posedge clk);
        #1;
        assert(out_rise == 1) else $error("Output did not go high on rising edge detection. Expected: 1, Got: %0d", out_rise);

        @(posedge clk);
        #1;
        assert(out_rise == 0) else $error("Output did not go low when input held high. Expected: 0, Got: %0d", out_rise);

        repeat (2) @(posedge clk);

        // test pulsing the input low
        in <= 0;
        #1;
        assert(out_fall == 0) else $error("Output went high too early on falling edge detection. Expected: 0, Got: %0d", out_fall);

        @(posedge clk);
        #1;
        assert(out_fall == 1) else $error("Output did not go high on falling edge detection. Expected: 1, Got: %0d", out_fall);

        in <= 1; repeat(2) @(posedge clk);

        // test holding the input low
        in <= 0;
        #1;
        assert(out_fall == 0) else $error("Output went high too early on falling edge detection. Expected: 0, Got: %0d", out_fall);

        @(posedge clk);
        #1;
        assert(out_fall == 1) else $error("Output did not go high on falling edge detection. Expected: 1, Got: %0d", out_fall);

        @(posedge clk);
        #1;
        assert(out_fall == 0) else $error("Output did not go low when input held low. Expected: 0, Got: %0d", out_fall);

        repeat(2) @(posedge clk);
 
        $stop;
	end
endmodule