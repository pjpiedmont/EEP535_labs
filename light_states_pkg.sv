package light_states_pkg;
	typedef enum logic [2:0] {
		LEFT = 3'b100,
		MIDDLE = 3'b010,
		RIGHT = 3'b001,
		OUTSIDE = 3'b101
	} light_states_e;
endpackage