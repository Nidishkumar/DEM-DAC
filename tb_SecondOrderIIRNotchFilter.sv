// Testbench for SecondOrderIIRNotchFilter module
// Description: Tests the functionality of the SecondOrderIIRNotchFilter module with various input signals.
// Author: [Your Name]
// Date: [Date]
// Version: 1.1

module tb_SecondOrderIIRNotchFilter;

    // Parameters
    parameter WIDTH = 16;

    // Inputs to the DUT
    logic clk_i;                             // Clock signal
    logic reset_i;                           // Reset signal
    logic signed [WIDTH-1:0] x_in_i;         // Input signal to the DUT

    // Outputs from the DUT
    logic signed [4*WIDTH-1:0] y_out_o;      // Filtered output signal
    logic signed [WIDTH-1:0] ntf_out_o;      // Noise Transfer Function (NTF) output
    logic signed [4*WIDTH-1:0] x_prev1_o;    // Previous input x[n-1]
    logic signed [4*WIDTH-1:0] x_prev2_o;    // Previous input x[n-2]
    logic signed [4*WIDTH-1:0] y_prev1_o;    // Previous output y[n-1]
    logic signed [4*WIDTH-1:0] y_prev2_o;    // Previous output y[n-2]

    // Instantiate the DUT (Device Under Test) with parameter WIDTH defined
    SecondOrderIIRNotchFilter  uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .y_out_o(y_out_o),
        .ntf_out_o(ntf_out_o),
        .x_prev1_o(x_prev1_o),
        .x_prev2_o(x_prev2_o),
        .y_prev1_o(y_prev1_o),
        .y_prev2_o(y_prev2_o)
    );

    // Clock generation (100 MHz clock, 10 ns period)
    always #5 clk_i = ~clk_i;

    // Testbench procedure
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 0;
        x_in_i = 0;

        // Apply reset
        $display("Applying reset...");
        reset_i = 1;
        #10; // Hold reset for 2 clock cycles
        reset_i = 0;

        // Test case 1: Step input, constant value
        x_in_i = 16'sd50;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 1");

        // Test case 2: Zero input after reset
        x_in_i = 16'd0;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 2");

        // Test case 3: Positive small input
        x_in_i = 16'sd20;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 3");

        // Test case 4: Negative input
        x_in_i = -16'sd150;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 4");

        // Test case 5: Large positive input
        x_in_i = 16'sd1000;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 5");

        // Test case 6: Oscillating input
        repeat (5) begin
            x_in_i = -x_in_i; // Alternate between positive and negative
            #10; // Wait for 1 clock cycle
            display_signals("Test Case 6 - Oscillation");
        end

        // Test case 7: Large negative input
        x_in_i = -16'sd2000;
        #10; // Wait for 1 clock cycle
        display_signals("Test Case 7");

        // End of simulation
        $display("Test completed.");
        $finish;
    end

    // Task to display signals for debugging
    task display_signals(input string test_case);
        $display("[%0s] | Input: %d | Output: %d | NTF: %d",
                 test_case, x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1: %d | x_prev2: %d", x_prev1_o, x_prev2_o);
        $display("y_prev1: %d | y_prev2: %d", y_prev1_o, y_prev2_o);
    endtask

endmodule
