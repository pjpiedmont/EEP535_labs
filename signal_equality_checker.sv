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
    localparam WIDTH = 4;

    logic             equal;
    logic [WIDTH-1:0] signal0;
    logic [WIDTH-1:0] signal1;

    signal_equality_checker #(.WIDTH(WIDTH)) dut(.equal, .signal0, .signal1);

    localparam TOTAL_TEST_CASES = 2 ** (WIDTH * 2);

    typedef struct {
        logic [WIDTH-1:0] signal0;
        logic [WIDTH-1:0] signal1;
        logic             expected_equal;
    } test_case_t;

    test_case_t test_cases[TOTAL_TEST_CASES];

    integer i;
    integer failure_count = 0;

    initial begin
        // Set up test cases
        for (i = 0; i < TOTAL_TEST_CASES; i++) begin
            { test_cases[i].signal1, test_cases[i].signal0 } = i;
            test_cases[i].expected_equal = (test_cases[i].signal0 == test_cases[i].signal1);
        end

        // Run test cases
        for (i = 0; i < TOTAL_TEST_CASES; i++) begin
            signal0 = test_cases[i].signal0;
            signal1 = test_cases[i].signal1;

            #10;

            assert (equal === test_cases[i].expected_equal) else begin
                failure_count++;
                $error("Test case %0d failed: signal0=%b, signal1=%b, expected_equal=%b, actual_equal=%b",
                        i, signal0, signal1, test_cases[i].expected_equal, equal);
            end
        end

        $display("Testbench completed. Failures: %0d", failure_count);
    end
endmodule