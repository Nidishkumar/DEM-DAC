// Testbench for TopModule
// Description: Testbench to verify functionality of TopModule
// Date: 2025-01-16
// Version: 1.0
// Author: [Your Name]

// Testbench for TopModule
// Description: Testbench to verify functionality of TopModule
// Date: 2025-01-16
// Version: 1.0
// Author: [Your Name]

`include "lib_switchblock_pkg.sv"
`include "TopModule.sv"
import lib_switchblock_pkg::*;

module tb_TopModule;

    // Inputs to the DUT
    logic clk_i;                      // Clock signal
    logic reset_i;                    // Reset signal
    logic [INPUT_WIDTH-1:0] x_in_i;   // Input signal

    // Outputs from the DUT
    logic [SWITCH_WIDTH-1:0] x_out1_o; // Output from SwitchingBlock
    logic [SWITCH_WIDTH-1:0] x_out2_o; // Output from SwitchingBlock
    logic [SWITCH_WIDTH-1:0] s_out_o;  // Output from SwitchingBlock

    // Internal signals for intermediate signals (from submodules)
    logic [INPUT_WIDTH-1:0] quant_out;  // Quantizer output
    logic [INPUT_WIDTH-1:0] quant_error;  // Quantizer error signal
    logic signed [INPUT_WIDTH-1:0] loop_filter_out; // Output from IIR filter
    logic pn_seq; // Pseudorandom sequence signal

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
    always #5 clk_i = ~clk_i;  // Toggle every 5ns for 100 MHz

    // Test procedure
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 1;
        x_in_i = 16'sd0;

        // Apply reset
        #10 reset_i = 0;  // Hold reset for 2 clock cycles
        #10 reset_i = 1;

        // Test Case 1: Step input signal
        x_in_i = 16'sd50;  // Step input signal
        #20; // Wait for a few clock cycles
        $display("Test Case 1 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);
/*
        // Test Case 2: Zero input signal
        x_in_i = 16'sd0;   // Zero input signal
        #20;
        $display("Test Case 2 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 3: Apply negative input signal
        x_in_i = -16'sd50; // Negative input signal
        #20;
        $display("Test Case 3 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 4: Test with large positive value
        x_in_i = 16'sd200;  // Large positive input signal
        #20;
        $display("Test Case 4 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 5: Apply edge case values for switching behavior
        x_in_i = 16'sd1000; // Test with larger input
        #20;
        $display("Test Case 5 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 6: Testing reset behavior after input signal changes
        reset_i = 1;  // Assert reset again
        #10 reset_i = 0;  // Deassert reset
        x_in_i = 16'sd75;  // Apply input after reset
        #20;
        $display("Test Case 6 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);

        // Test Case 7: Test PN sequence behavior (SwitchingBlock input)
        x_in_i = 16'sd60;
        #20;
        $display("Test Case 7 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in_i, x_out1_o, x_out2_o, s_out_o);
*/
        // End of test
        $finish;
    end

endmodule
