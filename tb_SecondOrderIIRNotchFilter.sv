// Testbench for SecondOrderIIRNotchFilter module
// Description: Tests the functionality of the SecondOrderIIRNotchFilter module with various input signals.
// Author: [Your Name]
// Date: [Date]
// Version: 1.1
`include "SecondOrderIIRNotchFilter.sv"
`include "lib_switchblock_pkg.sv"
 
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
    real x_input_real;         // Input signal to the DUT
    real output_real;         // Input signal to the DUT
    real x_prev1_r;
    real x_prev2_r;
    real y_prev1_r;
    real y_prev2_r;
    real ntf_out_r;
 
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
	 
 assign  output_real = $itor(y_out_o) / (1 << 16) ;
 assign   x_input_real = $itor(x_in_i);

 assign x_prev1_r = $itor(x_prev1_o) / (1 << 16) ;
 assign x_prev2_r = $itor(x_prev2_o) / (1 << 16) ;
 assign y_prev1_r = $itor(y_prev1_o) / (1 << 16) ;
 assign y_prev2_r = $itor(y_prev2_o) / (1 << 16) ;
 assign ntf_out_r = $itor(ntf_out_o)  ;
 


    // Clock generation (100 MHz clock, 10 ns period)
    always #5 clk_i = ~clk_i;
 
    // Testbench procedure
    initial begin

         $monitor($time," | Input: %f | Output: %f | NTF: %f   | x_prev1: %f | x_prev2: %f | y_prev1_o: %f | y_prev2_o:%f ", x_input_real, output_real, ntf_out_r, x_prev1_r, x_prev2_r, y_prev1_r, y_prev2_r);
 
        // Initialize signals
        clk_i = 1;
        reset_i = 1;
        x_in_i = 0;
        #10; 
        // Apply reset
        $display("Applying reset...");
        reset_i = 0;
        

        // Test case 1: Input value 50 (16-bit binary)
        //x_in_i = 16'b0000_0000_0011_0010; // 50 in binary
        x_in_i = 16'd30;
		  #10;
        //display_signals("Test Case 1");

        // Test case 2: Input value 20 (16-bit binary)
       // x_in_i = 16'b0000_0000_0001_0100; // 20 in binary
        x_in_i = 16'd20;
        #10;
       // display_signals("Test Case 2");

        // Test case 3: Input value 20 (16-bit binary)
       // x_in_i = 16'b0000_0000_0001_0100; // 20 in binary
        x_in_i = 16'd1000;
        #10;
       // display_signals("Test Case 2");
        
        // End of simulation
        $display("Test completed.");
        #100
        $finish;
    end

    
    // Task to display signals for debugging
   /* task display_signals(input string test_case);
        $display("[%0s] | Input: %d | Output: %d | NTF: %d",test_case, x_in_i,output_real , ntf_out_o);
        $display("x_prev1: %d | x_prev2: %d", x_prev1_o, x_prev2_o);
        $display("y_prev1: %d | y_prev2: %d", y_prev1_o, y_prev2_o);
    endtask*/
 
endmodule
