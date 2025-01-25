// Testbench for SecondOrderIIRNotchFilter module
// Description: Tests the functionality of the SecondOrderIIRNotchFilter module with various input signals.
// Author: 
// Date: 
// Version: 1.1

// `include "SecondOrderIIRNotchFilter.sv"
// `include "lib_switchblock_pkg.sv"

import lib_switchblock_pkg::*;  // Importing necessary package for switchblock functionality.

module tb_SecondOrderIIRNotchFilter;

    // Inputs to the DUT
    logic clk_i;                             // Clock signal
    logic reset_i;                           // Reset signal
    logic signed [WIDTH-1:0] x_in_i;         // Input signal to the DUT

    // Outputs from the DUT
    logic signed [2*WIDTH-1:0] y_out_o;      // Filtered output signal
    logic signed [WIDTH-1:0] ntf_out_o;      // Noise Transfer Function (NTF) output
    logic signed [2*WIDTH-1:0] x_prev1_o;    // Previous input x[n-1]
    logic signed [2*WIDTH-1:0] x_prev2_o;    // Previous input x[n-2]
    logic signed [2*WIDTH-1:0] y_prev1_o;    // Previous output y[n-1]
    logic signed [2*WIDTH-1:0] y_prev2_o;    // Previous output y[n-2]

    // Real representations for scaled values
    real x_input_real;
    real output_real;
    real x_prev1_r;
    real x_prev2_r;
    real y_prev1_r;
    real y_prev2_r;
    real ntf_out_r;

    // Instantiate the DUT (Device Under Test)
    SecondOrderIIRNotchFilter uut (
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

    // Real value assignments
    assign output_real = $itor(y_out_o) / (1 << 16);
    assign x_input_real = $itor(x_in_i);
    assign x_prev1_r = $itor(x_prev1_o) / (1 << 16);
    assign x_prev2_r = $itor(x_prev2_o) / (1 << 16);
    assign y_prev1_r = $itor(y_prev1_o) / (1 << 16);
    assign y_prev2_r = $itor(y_prev2_o) / (1 << 16);
    assign ntf_out_r = $itor(ntf_out_o);

    // Clock generation (100 MHz clock, 10 ns period)
     always #5 clk_i = ~clk_i;

    // Testbench procedure
    initial begin
        // Monitor signal values
        $monitor($time, " | Input: %f | Output: %f | NTF: %f | x_prev1: %f | x_prev2: %f | y_prev1: %f | y_prev2: %f",
                 x_input_real, output_real, ntf_out_r, x_prev1_r, x_prev2_r, y_prev1_r, y_prev2_r);

        // Initialize signals
        clk_i = 1;
        reset_i = 1;
        x_in_i = 0;
        #10;

        // Apply reset
        $display("Applying reset...");
        reset_i = 0;

        // Test case 1: Input value 30
        x_in_i = 16'd30;
        #10;

        // Test case 2: Input value 20
        x_in_i = 16'd20;
        #10;

        // Test case 3: Input value 1000
        x_in_i = 16'd1000;
        #10;
		  
	 // Test case 4: Input value 500
        x_in_i = 16'd500;
        #10;

       // Test case 5: Input value 1500
        x_in_i = 16'd1500;
        #10;

       // Test case 6: Input value 3500
        x_in_i = 16'd3500;
        #10;

      // Test case 7: Input value 4500
       x_in_i = 16'd4500;
        #10;


        // End of simulation
        $display("Test completed.");
        #100;
        $finish;
    end

endmodule
