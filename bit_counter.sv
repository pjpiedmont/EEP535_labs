module bit_counter #(
    parameter int WIDTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic [WIDTH - 1:0] a,
    output logic [$clog2(WIDTH):0] count,
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

    bit_counter_datapath #(.WIDTH(WIDTH)) datapath(
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
    parameter int WIDTH = 8;

    logic clk;
    logic reset;
    logic start;
    logic [WIDTH - 1:0] a;
    logic [$clog2(WIDTH):0] count;
    logic done;

    bit_counter #(.WIDTH(WIDTH)) dut(.clk, .reset, .start, .a, .count, .done);

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        int i;
        int failureCount = 0;

        reset <= 0;
        start <= 0;
        @(posedge clk);

        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        repeat (2) @(posedge clk);

        for (i = 0; i < 2 ** WIDTH; i++) begin
            a <= i;
            @(posedge clk);

            start <= 1;
            repeat (10) @(posedge clk);
            #1;

            assert(done == 1) else $error("Computation did not finish on time.");
            assert(count == $countones(i)) else begin
                $error("Ones count is incorrect. Expected %0d, got %0d.", $countones(i), count);
                failureCount++;
            end

            start <= 0;
            @(posedge clk);
        end

        $display("Failed tests: %0d", failureCount);
        $stop;
    end
endmodule