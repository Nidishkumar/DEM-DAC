`timescale 1ns/1ps

module tb_SwitchingBlock;

     // Parameters
    parameter WIDTH = 5;

    // Testbench signals
    logic clk;
    logic reset;
    logic [WIDTH-1:0] x_in;
    logic pn_seq;
    logic [WIDTH-1:0] x_out1;
    logic [WIDTH-1:0] x_out2;
    logic [WIDTH-1:0] s_out;

    // DUT instance
    SwitchingBlock #(.WIDTH(WIDTH)) dut (
        .clk_i(clk),
        .reset_i(reset),
        .x_in_i(x_in),
        .pn_seq_i(pn_seq),
        .x_out1_o(x_out1),
        .x_out2_o(x_out2),
        .s_out_o(s_out)
    );

    // Clock generation
    always #5 clk = ~clk; // Clock toggling for simulation

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        x_in = 0;
        pn_seq = 0;

        // Wait for reset deassertion
        #15;
        reset = 0;

        // Apply various test cases with different x_in and pn_seq values

        // Test Case 1: Odd input (x_in = 3) and pn_seq = 1
        #10 x_in = 3; pn_seq = 1;

        // Test Case 2: Odd input (x_in = 5) and pn_seq = 0
        #10 x_in = 5; pn_seq = 0;

        // Test Case 3: Even input (x_in = 4) and pn_seq = 1
        #10 x_in = 4; pn_seq = 1;

        // Test Case 4: Even input (x_in = 6) and pn_seq = 0
        #10 x_in = 6; pn_seq = 0;

        // Test Case 5: Odd input (x_in = 7) and pn_seq = 1
        #10 x_in = 7; pn_seq = 1;

        // Test Case 6: Odd input (x_in = 9) and pn_seq = 0
        #10 x_in = 9; pn_seq = 0;

        // Test Case 7: Even input (x_in = 10) and pn_seq = 1
        #10 x_in = 10; pn_seq = 1;

        // Test Case 8: Even input (x_in = 12) and pn_seq = 0
        #10 x_in = 12; pn_seq = 0;

        // Test Case 9: Zero input (x_in = 0) and pn_seq = 1
        #10 x_in = 0; pn_seq = 1;

        // Test Case 10: Zero input (x_in = 0) and pn_seq = 0
        #10 x_in = 0; pn_seq = 0;

        // Reset test
        #10 reset = 1; // Assert reset
        #10 reset = 0; // Deassert reset

        // End simulation
        #10 $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | x_in: %d | pn_seq: %b | x_out1: %d | x_out2: %d | s_out: %d",
                 $time, clk, reset, x_in, pn_seq, x_out1, x_out2, s_out);
    end

endmodule
