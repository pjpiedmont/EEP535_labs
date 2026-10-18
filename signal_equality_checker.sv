/**
 * signal_equality_checker.sv
 *
 * Checks whether two signals of arbitrary width have the same value.
 *
 * Parameters:
 * - WIDTH: The width of the signals to be compared
 *
 * Inputs:
 * - signal0: First signal to be compared
 * - signal1: Second signal to be compared
 *
 * Outputs:
 * - equal: Whether both signals are equal
 */
module signal_equality_checker #(
    parameter WIDTH = 4
)(
    output logic             equal,
    input  logic [WIDTH-1:0] signal0,
    input  logic [WIDTH-1:0] signal1
);
    assign equal = (signal0 == signal1);
endmodule

module signal_equality_checker_testbench();
    parameter WIDTH = 4;

    logic             equal;
    logic [WIDTH-1:0] signal0;
    logic [WIDTH-1:0] signal1;

    signal_equality_checker #(.WIDTH(WIDTH)) dut(.equal, .signal0, .signal1);

    integer i;
    initial begin
        for (i = 0; i < 2 ** (WIDTH * 2); i++) begin
            { signal1, signal0 } = i; #10;
        end
    end
endmodule