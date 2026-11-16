module bit_counter_controller(
    input  logic clk,
    input  logic reset,
    input  logic start,

    // status signals from datapath
    input  logic a0,
    input  logic a_equals_0,

    // control signals to datapath
    output logic reset_count,
    output logic increment_count,
    output logic load_a,
    output logic right_shift_a,
    output logic done
);
    typedef enum logic [1:0] { LOAD, COUNT, DONE } state_t;
    state_t ps, ns;

    // DFFs
    always_ff @(posedge clk) begin
        if (reset)
            ps <= LOAD;
        else
            ps <= ns;
    end

    // next state logic
    always_comb begin
        case (ps)
            LOAD:  ns = start ? COUNT : LOAD;
            COUNT: ns = a_equals_0 ? DONE : COUNT;
            DONE:  ns = start ? DONE : LOAD;
        endcase
    end

    // output logic
    assign reset_count = (ps == LOAD);
    assign increment_count = (ps == COUNT) & ~a_equals_0 & a0;
    assign load_a = (ps == LOAD);
    assign right_shift_a = (ps == COUNT);
    assign done = (ps == DONE);
endmodule



module bit_counter_controller_tb();
    localparam CLOCK_PERIOD = 100;

    logic clk;
    logic reset;
    logic start;
    logic a0;
    logic a_equals_0;
    logic reset_count;
    logic increment_count;
    logic load_a;
    logic right_shift_a;
    logic done;

    bit_counter_controller dut(.clk, .reset, .start, .a0, .a_equals_0, .reset_count, .increment_count, .load_a, .right_shift_a, .done);

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        reset <= 0;
        start <= 0;
        a0 <= 0;
        a_equals_0 <= 0;
        @(posedge clk);

        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);

        repeat (2) @(posedge clk);

        start <= 1;
        @(posedge clk);

        repeat (4) begin
            a0 <= 1;
            @(posedge clk);
            a0 <= 0;
            @(posedge clk);
        end

        a_equals_0 <= 1;

        repeat (2) @(posedge clk);

        start <= 0;

        repeat (2) @(posedge clk);

        $stop;
    end
endmodule