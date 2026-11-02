module play_field(
	input  logic clk,
	input  logic reset,
	input  logic leftLight,
	input  logic rightLight,
	input  logic buttonPlayer1,
	input  logic buttonPlayer2,
	output logic player1Wins,
	output logic player2Wins
);
	play_field_states_pkg::play_field_states_e ps, ns;

	// next state logic
	always_comb begin
		unique case ({ ps, leftLight, rightLight, buttonPlayer1, buttonPlayer2 })
			{ play_field_states_pkg::PLAYING, 1'b1, *, 1'b1, * }: ns = play_field_states_pkg::PLAYER_1_WINS;
			{ play_field_states_pkg::PLAYING, *, 1'b1, *, 1'b1 }: ns = play_field_states_pkg::PLAYER_2_WINS;
			{ play_field_states_pkg::PLAYING, *, *, 1'b0, 1'b0 }: ns = play_field_states_pkg::PLAYING;
			{ play_field_states_pkg::PLAYER_1_WINS, *, *, *, * }: ns = play_field_states_pkg::PLAYER_1_WINS;
			{ play_field_states_pkg::PLAYER_2_WINS, *, *, *, * }: ns = play_field_states_pkg::PLAYER_2_WINS;
		endcase
	end

	// output logic
	always_comb begin
		case (ps)
			play_field_states_pkg::PLAYING:
				player1Wins = 1'b0;
				player2Wins = 1'b0;
			play_field_states_pkg::PLAYER_1_WINS:
				player1Wins = 1'b1;
				player2Wins = 1'b0;
			play_field_states_pkg::PLAYER_2_WINS:
				player1Wins = 1'b0;
				player2Wins = 1'b1;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= play_field_states_pkg::PLAYING;
		else
			ps <= ns;
	end
endmodule