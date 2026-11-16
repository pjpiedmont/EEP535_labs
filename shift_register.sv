module shift_register #(
    parameter int WIDTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic [1:0] mode,
    input  logic left_in,
    input  logic right_in,
    input  logic [WIDTH - 1:0] parallel_in,
    output logic [WIDTH - 1:0] parallel_out
);
    typedef enum logic [1:0] {
        HOLD        = 2'b00,
        SHIFT_LEFT  = 2'b01,
        SHIFT_RIGHT = 2'b10,
        LOAD        = 2'b11
    } mode_t;

    always_ff @(posedge clk) begin
        if (reset)
            parallel_out <= '0;
        else begin
            case (mode)
                HOLD: parallel_out <= parallel_out;
                SHIFT_LEFT: parallel_out <= { parallel_out[WIDTH - 2:0], right_in };
                SHIFT_RIGHT: parallel_out <= { left_in, parallel_out[WIDTH - 1:1] };
                LOAD: parallel_out <= parallel_in;
            endcase
        end
    end
endmodule



module shift_register_tb();
    localparam WIDTH = 8;
    localparam CLOCK_PERIOD = 100;

    logic clk;
    logic reset;
    logic [1:0] mode;
    logic left_in;
    logic right_in;
    logic [WIDTH - 1:0] parallel_in;
    logic [WIDTH - 1:0] parallel_out;

    shift_register #(.WIDTH(WIDTH)) dut(.clk, .reset, .mode, .left_in, .right_in, .parallel_in, .parallel_out);

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        int failureCount = 0;

        reset <= 0;
        mode <= 0;
        left_in <= 0;
        right_in <= 1;
        parallel_in <= 0;
        @(posedge clk);

        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);

        // load value into shift register
        mode <= 2'b11;
        parallel_in <= {(WIDTH / 2){2'b10}};
        @(posedge clk);
        mode <= 0;
        @(posedge clk);

        // shift left 2 bits
        mode <= 2'b01;

        @(posedge clk);
        #1;
        assert(parallel_out == 8'b0101_0101) else begin
            $error("Left shift was not performed successfully. Expected %0d, got %0d.", 8'b0101_0101, parallel_out);
            failureCount++;
        end

        @(posedge clk);
        #1;
        assert(parallel_out == 8'b1010_1011) else begin
            $error("Left shift was not performed successfully. Expected %0d, got %0d.", 8'b1010_1011, parallel_out);
            failureCount++;
        end

        // shift right 2 bits
        mode <= 2'b10;

        @(posedge clk);
        #1;
        assert(parallel_out == 8'b0101_0101) else begin
            $error("Right shift was not performed successfully. Expected %0d, got %0d.", 8'b0101_0101, parallel_out);
            failureCount++;
        end

        @(posedge clk);
        #1;
        assert(parallel_out == 8'b0010_1010) else begin
            $error("Right shift was not performed successfully. Expected %0d, got %0d.", 8'b0010_1010, parallel_out);
            failureCount++;
        end

        mode <= 0;
        repeat (2) @(posedge clk);

        $display("Failed tests: %0d", failureCount);
        $stop;
    end
endmodule