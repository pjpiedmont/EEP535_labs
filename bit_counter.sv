module bit_counter #(
    parameter  int INPUT_WIDTH = 8,
    localparam int COUNTER_WIDTH = $clog2(INPUT_WIDTH) + 1
)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic [INPUT_WIDTH - 1:0] a,
    output logic [COUNTER_WIDTH - 1:0] count,
    output logic done
);
    // internal signals
    logic reset_count;
    logic increment_count;
    logic load_a;
    logic right_shift_a;
    logic a_equals_0;
    logic a0;

    bit_counter_controller controller(
        .clk,
        .reset,
        .start,
        .a0,
        .a_equals_0,
        .reset_count,
        .increment_count,
        .load_a,
        .right_shift_a,
        .done
    );

    bit_counter_datapath #(.INPUT_WIDTH(INPUT_WIDTH)) datapath(
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
endmodule



module bit_counter_tb();
    localparam int CLOCK_PERIOD = 100;
    parameter  int INPUT_WIDTH = 8;
    localparam int COUNTER_WIDTH = $clog2(INPUT_WIDTH) + 1;

    logic clk;
    logic reset;
    logic start;
    logic [INPUT_WIDTH - 1:0] a;
    logic [COUNTER_WIDTH - 1:0] count;
    logic done;

    assign a = 8'b0101_0101;

    bit_counter #(.INPUT_WIDTH(INPUT_WIDTH)) dut(.clk, .reset, .start, .a, .count, .done);

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        reset <= 0;
        start <= 0;
        @(posedge clk);

        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        repeat (2) @(posedge clk);

        start <= 1;
        @(posedge clk);

        repeat (9) @(posedge clk);
        #1;

        assert(done == 1) else $error("Computation did not finish on time.");
        assert(count == 4) else $error("Ones count is incorrect. Expected %0d, got %0d.", 4, count);

        $stop;
    end
endmodule