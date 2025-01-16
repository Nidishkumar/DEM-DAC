// Testbench for SecondOrderIIRNotchFilter module
// Description: Tests the functionality of the SecondOrderIIRNotchFilter module with various input signals.
// Date: 
// Version: 1.0
// Author: 

module tb_SecondOrderIIRNotchFilter;

    // Parameters
    parameter WIDTH = 16;

    // Inputs to the DUT
    logic clk_i;
    logic reset_i;
    logic signed [WIDTH-1:0] x_in_i;

    // Outputs from the DUT
    logic signed [4*WIDTH-1:0] y_out_o;
    logic signed [WIDTH-1:0] ntf_out_o;
    logic signed [4*WIDTH-1:0] x_prev1_o;
    logic signed [4*WIDTH-1:0] x_prev2_o;
    logic signed [4*WIDTH-1:0] y_prev1_o;
    logic signed [4*WIDTH-1:0] y_prev2_o;

    // Instantiate the DUT (Device Under Test)
    SecondOrderIIRNotchFilter #(
        .WIDTH(WIDTH)
    ) uut (
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

    // Clock generation (100 MHz clock, 10ns period)
    always #5 clk_i = ~clk_i;

    // Test procedure
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
        $display("Test Case 1 -> Input:%d, Output:%d, NTF:%d", x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1:%d, x_prev2:%d", x_prev1_o, x_prev2_o);
        $display("y_prev1:%d, y_prev2:%d", y_prev1_o, y_prev2_o);

        // Test case 2: Reset and zero input
        reset_i = 1;
        #10; // Hold reset for 2 clock cycles
        reset_i = 0;
        x_in_i = 16'sd0;
        #10; // Wait for 1 clock cycle
        $display("Test Case 2 -> Input:%d, Output:%d, NTF:%d", x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1:%d, x_prev2:%d", x_prev1_o, x_prev2_o);
        $display("y_prev1:%d, y_prev2:%d", y_prev1_o, y_prev2_o);

        // Test case 3: Positive input signal
        x_in_i = 16'sd20;
        #10; // Wait for 1 clock cycle
        $display("Test Case 3 -> Input:%d, Output:%d, NTF:%d", x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1:%d, x_prev2:%d", x_prev1_o, x_prev2_o);
        $display("y_prev1:%d, y_prev2:%d", y_prev1_o, y_prev2_o);

        // Test case 4: Negative input signal
        x_in_i = -16'sd150;
        #10; // Wait for 1 clock cycle
        $display("Test Case 4 -> Input:%d, Output:%d, NTF:%d", x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1:%d, x_prev2:%d", x_prev1_o, x_prev2_o);
        $display("y_prev1:%d, y_prev2:%d", y_prev1_o, y_prev2_o);

        // Test case 5: Larger input signal
        x_in_i = 16'sd1000;
        #10; // Wait for 1 clock cycle
        $display("Test Case 5 -> Input:%d, Output:%d, NTF:%d", x_in_i, y_out_o, ntf_out_o);
        $display("x_prev1:%d, x_prev2:%d", x_prev1_o, x_prev2_o);
        $display("y_prev1:%d, y_prev2:%d", y_prev1_o, y_prev2_o);

        // End of test
        $display("Test completed.");
        $finish;
    end

endmodule 
