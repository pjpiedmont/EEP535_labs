module hazard_lights (
	input  logic clk,
	input  logic reset,
	input  wind_directions_pkg::wind_directions_e wind,
	output logic [2:0] lights
);
	// state variables
	light_states_pkg::light_states_e ps, ns;

	// output logic
	always_comb begin
		case (ps)
			light_states_pkg::LEFT:    lights = 3'b100;
			light_states_pkg::MIDDLE:  lights = 3'b010;
			light_states_pkg::RIGHT:   lights = 3'b001;
			light_states_pkg::OUTSIDE: lights = 3'b101;
		endcase
	end

	// next state logic
	always_comb begin
		unique case({ ps, wind })
			{ light_states_pkg::LEFT,    wind_directions_pkg::CALM }:  ns = light_states_pkg::OUTSIDE;
			{ light_states_pkg::LEFT,    wind_directions_pkg::LEFT }:  ns = light_states_pkg::RIGHT;
			{ light_states_pkg::LEFT,    wind_directions_pkg::RIGHT }: ns = light_states_pkg::MIDDLE;
			{ light_states_pkg::MIDDLE,  wind_directions_pkg::CALM }:  ns = light_states_pkg::OUTSIDE;
			{ light_states_pkg::MIDDLE,  wind_directions_pkg::LEFT }:  ns = light_states_pkg::LEFT;
			{ light_states_pkg::MIDDLE,  wind_directions_pkg::RIGHT }: ns = light_states_pkg::RIGHT;
			{ light_states_pkg::RIGHT,   wind_directions_pkg::CALM }:  ns = light_states_pkg::OUTSIDE;
			{ light_states_pkg::RIGHT,   wind_directions_pkg::LEFT }:  ns = light_states_pkg::MIDDLE;
			{ light_states_pkg::RIGHT,   wind_directions_pkg::RIGHT }: ns = light_states_pkg::LEFT;
			{ light_states_pkg::OUTSIDE, wind_directions_pkg::CALM }:  ns = light_states_pkg::MIDDLE;
			{ light_states_pkg::OUTSIDE, wind_directions_pkg::LEFT }:  ns = light_states_pkg::RIGHT;
			{ light_states_pkg::OUTSIDE, wind_directions_pkg::RIGHT }: ns = light_states_pkg::LEFT;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= light_states_pkg::MIDDLE;
		else
			ps <= ns;
	end
endmodule



module hazard_lights_testbench();
	logic       clk, reset;
	wind_directions_pkg::wind_directions_e wind;
	logic [2:0] lights;

	hazard_lights dut (.clk, .reset, .wind, .lights);

	parameter CLOCK_PERIOD = 100;

	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
			@(posedge clk);
		reset <= 1; wind <= wind_directions_pkg::CALM; @(posedge clk);
		reset <= 0; @(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
		wind <= wind_directions_pkg::LEFT; @(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
		wind <= wind_directions_pkg::RIGHT; @(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);

		$stop; // End the simulation.
	end
endmodule