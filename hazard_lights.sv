module hazard_lights (
	input  logic       clk,
	input  logic       reset,
	input  logic [1:0] wind,
	output logic [2:0] lights
);
	// state variables
	enum { left_light, middle_light, right_light, outside_lights } ps, ns;

	// output logic
	always_comb begin
		case (ps)
			left_light:     lights = 3'b100;
			middle_light:   lights = 3'b010;
			right_light:    lights = 3'b001;
			outside_lights: lights = 3'b101;
		endcase
	end

	// wind enum to make code more readable
	enum { calm = 2'b00, left_wind = 2'b01, right_wind = 2'b10 } wind_states;

	// next state logic
	always_comb begin
		unique case({ ps, wind })
			{ left_light,     calm }:       ns = outside_lights;
			{ left_light,     left_wind }:  ns = right_light;
			{ left_light,     right_wind }: ns = middle_light;
			{ middle_light,   calm }:       ns = outside_lights;
			{ middle_light,   left_wind }:  ns = left_light;
			{ middle_light,   right_wind }: ns = right_light;
			{ right_light,    calm }:       ns = outside_lights;
			{ right_light,    left_wind }:  ns = middle_light;
			{ right_light,    right_wind }: ns = left_light;
			{ outside_lights, calm }:       ns = middle_light;
			{ outside_lights, left_wind }:  ns = left_light;
			{ outside_lights, right_wind }: ns = right_light;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= outside_lights;
		else
			ps <= ns;
	end
endmodule