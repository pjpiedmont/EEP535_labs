module counter #(
    parameter MAX_COUNT = 8'hff
)(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic [$clog2(MAX_COUNT) - 1:0] count
);
    always_ff @(posedge clk) begin
        if (reset)
            count <= 0;
        else if (enable)
            count <= (count == MAX_COUNT) ? 0 : count + 1;
    end
endmodule


module counter_tb();
    localparam CLOCK_PERIOD = 100;
    localparam MAX_COUNT = 4'hf;
    localparam COUNT_WIDTH = $clog2(MAX_COUNT);

    logic clk, reset, enable;
    logic [COUNT_WIDTH - 1:0] count;

    counter #(.MAX_COUNT(MAX_COUNT)) dut(.clk, .reset, .enable, .count);

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        @(posedge clk);

        // reset
        reset <= 1; enable <= 0; @(posedge clk);
        reset <= 0; @(posedge clk);

        // count from 0 to 1
        enable <= 1; @(posedge clk);
        enable <= 0; @(posedge clk);

        // count from 1 to MAX_COUNT
        enable <= 1; @(posedge clk);
        repeat (MAX_COUNT - 1) @(posedge clk);
        assert(count == MAX_COUNT) else $error("Count did not reach MAX_COUNT. Expected: %0d, Got: %0d", MAX_COUNT, count);

        // wrap around to 0
        @(posedge clk);
        assert(count == 0) else $error("Count did not wrap around to 0. Expected: 0, Got: %0d", count);

        $stop;
    end
endmodule