// Module name: Switching Block layers test bench
// Description:Verifies the two layers design 2 layers
// Date: 
// Version: 1.0
// Author: 
import lib_switchblock_pkg::*;
module tb_SwitchingBlockLayers_2;
    // Inputs to the DUT
    logic clk_i;
    logic reset_i;
    logic [INPUT_WIDTH-1:0] x_in_i;
    // Outputs from the DUT (Separate signals instead of an array)
    logic [INPUT_WIDTH-1:0] x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o;
    // Instantiate the DUT (Device Under Test)
    SwitchingBlockLayers_2 uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out2_1_o(x_out2_1_o),
        .x_out2_2_o(x_out2_2_o),
        .x_out2_3_o(x_out2_3_o),
        .x_out2_4_o(x_out2_4_o)
    );
    // Clock generation (100 MHz clock)
    always #5 clk_i = ~clk_i;  // Toggle every 5 ns
    // Test procedure
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 1;
        x_in_i = 0;
        // Apply reset
        #10 reset_i = 0;
        // Test Case 1: Step input signal
        x_in_i = 16'd50000;
        #20;
        $display("Test 1 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
//      // Test Case 2: Zero input signal
//        x_in_i = 0;
//        #20;
//        $display("Test 2 -> Input: %d | Outputs: %d, %d, %d, %d", 
//                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Test Case 3: Negative input signal
        x_in_i = -16'sd45000;
        #20;
        $display("Test 3 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Test Case 4: Large positive value
        x_in_i = 16'sd65000;
        #20;
        $display("Test 4 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Test Case 5: Edge case switching behavior
        x_in_i = 16'sd10000;
        #20;
        $display("Test 5 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Test Case 6: Reset behavior
        reset_i = 1;
        #10 reset_i = 0;
        x_in_i = 16'sd25000;
        #20;
        $display("Test 6 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Test Case 7: Random input pattern
        x_in_i = 16'sd35000;
        #20;
        $display("Test 7 -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // Final Reset Test
        reset_i = 1;
        #10 reset_i = 0;
        x_in_i = 16'sd12345;
        #20;
        $display("Final Test -> Input: %d | Outputs: %d, %d, %d, %d", 
                  x_in_i, x_out2_1_o, x_out2_2_o, x_out2_3_o, x_out2_4_o);
        // End of test
        $finish;
    end
endmodule