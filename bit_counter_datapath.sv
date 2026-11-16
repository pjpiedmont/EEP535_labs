module bit_counter_datapath #(
    parameter int INPUT_WIDTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic [INPUT_WIDTH - 1:0] a,

    // control signals from controller
    input  logic reset_count,
    input  logic increment_count,
    input  logic load_a,
    input  logic right_shift_a,

    // status signals to controller
    output logic a_equals_0,
    output logic a0,

    output logic [$clog2(INPUT_WIDTH):0] count
);
    logic [INPUT_WIDTH - 1:0] a_reg;
    logic [1:0] shift_register_mode;

    shift_register #(.WIDTH(INPUT_WIDTH)) sr(
        .clk,
        .reset,
        .mode(shift_register_mode),
        .left_in(1'b0),
        .right_in(1'b0),
        .parallel_in(a),
        .parallel_out(a_reg)
    );

    always_ff @(posedge clk) begin
        if (reset_count)
            count <= 0;
        else if (increment_count)
            count <= count + 1;
        else
            count <= count;
    end

    always_comb begin
        if (load_a)
            shift_register_mode = 2'b11;
        else if (right_shift_a)
            shift_register_mode = 2'b10;
        else
            shift_register_mode = 2'b00;
    end

    assign a_equals_0 = (a_reg == '0);
    assign a0 = a_reg[0];
endmodule



module bit_counter_datapath_tb();
    localparam int CLOCK_PERIOD = 100;
    parameter int INPUT_WIDTH = 8;

    logic clk;
    logic reset;
    logic [INPUT_WIDTH - 1:0] a;
    logic reset_count;
    logic increment_count;
    logic load_a;
    logic right_shift_a;
    logic a_equals_0;
    logic a0;
    logic [$clog2(INPUT_WIDTH):0] count;

    assign a = 8'b0101_0101;

    bit_counter_datapath #(.INPUT_WIDTH(INPUT_WIDTH)) dut(
        .clk,
        .reset,
        .a,
        .reset_count,
        .increment_count,
        .load_a,
        .right_shift_a,
        .a_equals_0,
        .a0,
        .count
    );

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        reset <= 0;
        reset_count <= 0;
        increment_count <= 0;
        load_a <= 0;
        right_shift_a <= 0;
        @(posedge clk);

        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        load_a <= 1;
        reset_count <= 1;
        repeat (3) @(posedge clk);

        load_a <= 0;
        reset_count <= 0;
        right_shift_a <= 1;
        
        repeat (8) begin
            // simulate receiving an increment command from the controller
            increment_count <= a0;
            @(posedge clk);
        end

        assert(count == 4) else $error("Ones count is incorrect. Expected %0d, got %0d.", 4, count);

        $stop;
    end
endmodule