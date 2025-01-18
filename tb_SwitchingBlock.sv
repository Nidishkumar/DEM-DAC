// Module name: tb_SwitchingBlock
// Description: Testbench for the SwitchingBlock module. Implements various test cases to verify the functionality of switching logic.
// Author: [Your Name]
// Date: [Date]
// Version: [Version Number]

`timescale 1ns/1ps

module tb_SwitchingBlock;

    // Fixed width matching the SwitchingBlock module definition
    localparam WIDTH = 5;

    // Testbench signals
    logic clk_i;                       // Clock signal
    logic reset_i;                     // Reset signal
    logic [WIDTH-1:0] x_in_i;          // Input signal for DUT
    logic pn_seq_i;                    // Pseudorandom PN sequence for DUT
    logic [WIDTH-1:0] quantized_value_i; // Quantized value input for DUT
    logic [WIDTH-1:0] x_out1_o;        // Output 1 from DUT
    logic [WIDTH-1:0] x_out2_o;        // Output 2 from DUT
    logic [WIDTH-1:0] s_out_o;         // Switching sequence output from DUT

    // DUT instantiation without parameter override
    SwitchingBlock dut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .pn_seq_i(pn_seq_i),
        .quantized_value_i(quantized_value_i),
        .x_out1_o(x_out1_o),
        .x_out2_o(x_out2_o),
        .s_out_o(s_out_o)
    );

    // Clock generation
    always #5 clk_i = ~clk_i; // Generate a clock signal with a period of 10ns

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk_i = 0;
        reset_i = 1;
        x_in_i = 0;
        pn_seq_i = 0;
        quantized_value_i = 0;

        // Wait for reset deassertion
        #15;
        reset_i = 0;

        // Test cases

        // Test Case 1: quantized_value_i = 3, Odd input (x_in_i = 3), pn_seq_i = 1
        #10 quantized_value_i = 3; x_in_i = 3; pn_seq_i = 1;

        // Test Case 2: quantized_value_i = 5, Odd input (x_in_i = 5), pn_seq_i = 0
        #10 quantized_value_i = 5; x_in_i = 5; pn_seq_i = 0;

        // Test Case 3: quantized_value_i = 4, Even input (x_in_i = 4), pn_seq_i = 1
        #10 quantized_value_i = 4; x_in_i = 4; pn_seq_i = 1;

        // Test Case 4: quantized_value_i = 6, Even input (x_in_i = 6), pn_seq_i = 0
        #10 quantized_value_i = 6; x_in_i = 6; pn_seq_i = 0;

        // Test Case 5: quantized_value_i = 7, Odd input (x_in_i = 7), pn_seq_i = 1
        #10 quantized_value_i = 7; x_in_i = 7; pn_seq_i = 1;

        // Test Case 6: quantized_value_i = 2, Odd input (x_in_i = 9), pn_seq_i = 0
        #10 quantized_value_i = 2; x_in_i = 9; pn_seq_i = 0;

        // Test Case 7: quantized_value_i = 1, Even input (x_in_i = 10), pn_seq_i = 1
        #10 quantized_value_i = 1; x_in_i = 10; pn_seq_i = 1;

        // Test Case 8: quantized_value_i = 3, Even input (x_in_i = 12), pn_seq_i = 0
        #10 quantized_value_i = 3; x_in_i = 12; pn_seq_i = 0;

        // Test Case 9: quantized_value_i = 0, Zero input (x_in_i = 0), pn_seq_i = 1
        #10 quantized_value_i = 0; x_in_i = 0; pn_seq_i = 1;

        // Test Case 10: quantized_value_i = 0, Zero input (x_in_i = 0), pn_seq_i = 0
        #10 quantized_value_i = 0; x_in_i = 0; pn_seq_i = 0;

        // Reset Test
        #10 reset_i = 1; // Assert reset
        #10 reset_i = 0; // Deassert reset

        // End simulation
        #10 $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %0t | clk_i: %b | reset_i: %b | x_in_i: %d | pn_seq_i: %b | quantized_value_i: %d | x_out1_o: %d | x_out2_o: %d | s_out_o: %d",
                 $time, clk_i, reset_i, x_in_i, pn_seq_i, quantized_value_i, x_out1_o, x_out2_o, s_out_o);
    end

endmodule
