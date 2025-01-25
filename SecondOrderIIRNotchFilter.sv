// Module: SecondOrderIIRNotchFilter
// Description: Implements a second-order IIR notch filter using a difference equation.
// Date: 
// Version: 1.0
// Author:

//`include "qmul_fixed.sv"
//`include "qadd_fixed.sv"
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;  // Importing necessary package for shared parameters/constants
 
module SecondOrderIIRNotchFilter 
 
(
    input logic clk_i,                           // Clock signal
    input logic reset_i,                         // Reset signal
    input logic signed  [WIDTH-1:0] x_in_i,      // Current input signal (signed)
    output logic signed [2*WIDTH-1:0] y_out_o,   // Current output signal (signed)
    output logic signed [WIDTH-1:0] ntf_out_o,   // Noise Transfer Function output (signed)
 
    output logic signed [2*WIDTH-1:0] x_prev1_o, // Previous input x[n-1]
    output logic signed [2*WIDTH-1:0] x_prev2_o, // Previous input x[n-2]
    output logic signed [2*WIDTH-1:0] y_prev1_o, // Previous output y[n-1]
    output logic signed [2*WIDTH-1:0] y_prev2_o  // Previous output y[n-2]
);


 // Coefficients for the notch filter (10-bit signed values)
    logic signed [2*WIDTH-1:0] b0 = 32'b0000_0000_0000_0001_0000_0000_0000_0000;    // Numerator coefficient b0
    logic signed [2*WIDTH-1:0] b1 = 32'b1111_1111_1111_1110_0001_1001_0001_0111;   // Numerator coefficient b1  = -1.902
    logic signed [2*WIDTH-1:0] b2 = 32'b0000_0000_0000_0001_0000_0000_0000_0000;    // Numerator coefficient b2
    logic signed [2*WIDTH-1:0] a1 = 32'b1111_1111_1111_1110_0001_1101_1111_0100;   // Denominator coefficient a1 (negative) = -1.883
    logic signed [2*WIDTH-1:0] a2 = 32'b0000_0000_0000_0000_1111_1010_1110_0111;    // Denominator coefficient a2 = 0.9801
 
 // Temporary variables for Addition outputs
    logic signed [2*WIDTH-1:0] x_add1_out;
    logic signed [2*WIDTH-1:0] x_add2_out;
    logic signed [2*WIDTH-1:0] y_add1_out;
    logic signed [2*WIDTH-1:0] y_add2_out;

// Temporary variables for multiplication outputs
    logic signed [2*WIDTH-1:0] mul_a1_y1;
    logic signed [2*WIDTH-1:0] mul_a2_y2;
    logic signed [2*WIDTH-1:0] mul_b0_x;
    logic signed [2*WIDTH-1:0] mul_b1_x1;
    logic signed [2*WIDTH-1:0] mul_b2_x2;

    // Temporary variables for intermediate calculations
    logic signed [2*WIDTH-1:0] intermediate;
    logic signed [WIDTH-1:0] h_z;
    logic signed [2*WIDTH-1:0] temp_x_in;
    logic signed [2*WIDTH-1:0] temp_x_input;

    // assign temp_x_in    = x_in_i;
    assign temp_x_input = {x_in_i,{16{1'b0}}};
 
    // Instantiate multipliers
    qmul_fixed qmul_fixed_1 (.a_i(a1),.b_i(y_prev1_o),.product_o(mul_a1_y1));
                            
    qmul_fixed qmul_fixed_2 (.a_i(a2),.b_i(y_prev2_o),.product_o(mul_a2_y2));

    qmul_fixed qmul_fixed_3 (.a_i(b0),.b_i(temp_x_in),.product_o(mul_b0_x));

    qmul_fixed qmul_fixed_4 (.a_i(b1),.b_i(x_prev1_o),.product_o(mul_b1_x1));

    qmul_fixed qmul_fixed_5 (.a_i(b2),.b_i(x_prev2_o),.product_o(mul_b2_x2));

	 // Instantiate adders
    qadd_fixed qadd_fixed_1 (.a_i(mul_a1_y1),.b_i(mul_a2_y2),.result_o(y_add1_out));

    qadd_fixed qadd_fixed_2 (.a_i(y_add1_out),.b_i(mul_b0_x),.result_o(y_add2_out));

    qadd_fixed qadd_fixed_3 (.a_i(y_add2_out),.b_i(mul_b1_x1),.result_o(x_add1_out));

    qadd_fixed qadd_fixed_4 (.a_i(x_add1_out),.b_i(mul_b2_x2),.result_o(intermediate));

     // Assign outputs                   
    assign y_out_o = intermediate;
    assign h_z = intermediate[31:16];
 
    // Sequential logic for filter operation
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset all states and outputs to zero
            x_prev1_o <= 0;
            x_prev2_o <= 0;
            y_prev1_o <= 0;
            y_prev2_o <= 0;
            ntf_out_o <= 0;
            temp_x_in <= 0;
            //intermediate<=0;
            
        end else begin
            // Store the input in a temporary register
           temp_x_in <= temp_x_input;
            // Shift previous input and output values
            x_prev2_o <= x_prev1_o;
            x_prev1_o <= temp_x_in;
            y_prev2_o <= y_prev1_o;
            y_prev1_o <= y_out_o;
 
            // Calculate Noise Transfer Function (NTF) output
            if (h_z != 0) begin
                ntf_out_o <= ((16'sb1) - h_z) / h_z; // NTF = (1 - H(z)) / H(z)
            end else begin
                ntf_out_o <= 0; // Default to zero if division by zero
            end
        end
    end
endmodule