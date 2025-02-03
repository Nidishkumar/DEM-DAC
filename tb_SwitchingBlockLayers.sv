// Testbench for TopModule_Instantiations
// Description: Testbench to verify functionality of TopModule_Instantiations
// Date: 
// Version: 1.0
// Author: 

import lib_switchblock_pkg::*;

module tb_SwitchingBlockLayers;

    // Inputs to the DUT
    logic clk_i;                      // Clock signal
    logic reset_i;                    // Reset signal
    logic [INPUT_WIDTH-1:0] x_in_i;   // Input signal

    // Outputs from the DUT
    logic [INPUT_WIDTH-1:0] x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o;
    logic [INPUT_WIDTH-1:0] x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o;

    // Instantiate the DUT (Device Under Test)
    SwitchingBlockLayers uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out3_1_o(x_out3_1_o),
        .x_out3_2_o(x_out3_2_o),
        .x_out3_3_o(x_out3_3_o),
        .x_out3_4_o(x_out3_4_o),
        .x_out3_5_o(x_out3_5_o),
        .x_out3_6_o(x_out3_6_o),
        .x_out3_7_o(x_out3_7_o),
        .x_out3_8_o(x_out3_8_o)
    );

    // Clock generation (100 MHz clock)
    always #5 clk_i = ~clk_i;  // Toggle every 5 ns for a 100 MHz clock

    // Test procedure
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 1;
        x_in_i = 16'sd0;

        // Apply reset
        #10 reset_i = 1;  // Hold reset for 2 clock cycles
        #10 reset_i = 0;

        // Test Case 1: Step input signal
        x_in_i = 16'd50000;
        #30;
        $display("Test Case 1 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 2: Zero input signal
        x_in_i = 16'sd25000;
        #30;
        $display("Test Case 2 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 3: Apply negative input signal
        x_in_i = -16'sd45000;
        #30;
        $display("Test Case 3 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 4: Test with large positive value
        x_in_i = 16'sd65000;
        #30;
        $display("Test Case 4 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 5: Apply edge case values
        x_in_i = 16'sd10000;
        #30;
        $display("Test Case 5 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 6: Testing reset behavior
        reset_i = 1;
        #10 reset_i = 0;
        x_in_i = 16'sd25000;
        #30;
        $display("Test Case 6 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // Test Case 7: Random test case
        x_in_i = 16'sd35000;
        #30;
        $display("Test Case 7 -> Input:%d, Outputs:%d %d %d %d %d %d %d %d", x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o);

        // End of test
        $finish;
    end

endmodule

