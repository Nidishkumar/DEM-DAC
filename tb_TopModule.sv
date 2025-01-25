// Testbench for TopModule
// Description: Testbench to verify functionality of TopModule
// Date: 
// Version: 1.0
// Author: 

// Import required packages and modules
// `include "lib_switchblock_pkg.sv"
// `include "TopModule.sv"
import lib_switchblock_pkg::*;

module tb_TopModule;

    // Inputs to the DUT
    logic clk_i;                      // Clock signal
    logic reset_i;                    // Reset signal
    logic [INPUT_WIDTH-1:0] x_in_i;   // Input signal

    // Outputs from the DUT
    logic [INPUT_WIDTH-1:0] x_out1_o; // Output from SwitchingBlock
    logic [INPUT_WIDTH-1:0] x_out2_o; // Output from SwitchingBlock
    logic [INPUT_WIDTH-1:0] s_out_o;  // Output from SwitchingBlock

    // Instantiate the DUT (Device Under Test)
    TopModule uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out1_o(x_out1_o),
        .x_out2_o(x_out2_o),
        .s_out_o(s_out_o)
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
        x_in_i = 16'd50000;  // Step input signal
        #20;
        $display("Test Case 1 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 2: Zero input signal
        x_in_i = 16'sd0;   // Zero input signal
        #20;
        $display("Test Case 2 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 3: Apply negative input signal
        x_in_i = -16'sd45000; // Negative input signal
        #20;
        $display("Test Case 3 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 4: Test with large positive value
        x_in_i = 16'sd65000;  // Large positive input signal
        #20;
        $display("Test Case 4 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 5: Apply edge case values for switching behavior
        x_in_i = 16'sd10000; // Test with smaller input
        #20;
        $display("Test Case 5 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 6: Testing reset behavior after input signal changes
        reset_i = 1;  // Assert reset again
        #10 reset_i = 0;  // Deassert reset
        x_in_i = 16'sd25000;  // Apply input after reset
        #20;
        $display("Test Case 6 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 7: Test PN sequence behavior (SwitchingBlock input)
        x_in_i = 16'sd35000;
        #20;
        $display("Test Case 7 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // End of test
        $finish;
    end

endmodule
