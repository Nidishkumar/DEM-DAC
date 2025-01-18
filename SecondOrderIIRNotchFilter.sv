// Module name: SecondOrderIIRNotchFilter
// Description: Implements a second-order IIR notch filter using a difference equation.
//              Provides filtering with specified coefficients and computes the NTF.
// Date: 
// Version: 1.0
// Author: 

import lib_switchblock_pkg::*;

module SecondOrderIIRNotchFilter (
    input logic clk_i,                         // Clock signal
    input logic reset_i,                       // Reset signal
    input logic signed [WIDTH-1:0] x_in_i,     // Current input signal (signed)
    output logic signed [4*WIDTH-1:0] y_out_o, // Current output signal (signed)
    output logic signed [WIDTH-1:0] ntf_out_o, // Noise Transfer Function output (signed)

    output logic signed [4*WIDTH-1:0] x_prev1_o, // Previous input x[n-1]
    output logic signed [4*WIDTH-1:0] x_prev2_o, // Previous input x[n-2]
    output logic signed [4*WIDTH-1:0] y_prev1_o, // Previous output y[n-1]
    output logic signed [4*WIDTH-1:0] y_prev2_o  // Previous output y[n-2]
);

    // Coefficients for the notch filter (scaled for 16-bit signed values)
    logic signed [WIDTH-1:0] b0 = 16'sd32768;   // Numerator coefficient b0
    logic signed [WIDTH-1:0] b1 = -16'sd62325;  // Numerator coefficient b1
    logic signed [WIDTH-1:0] b2 = 16'sd32768;   // Numerator coefficient b2
    logic signed [WIDTH-1:0] a1 = -16'sd61702;  // Denominator coefficient a1 (negative)
    logic signed [WIDTH-1:0] a2 = 16'sd32116;   // Denominator coefficient a2

    // Temporary variables for intermediate calculations
    logic signed [4*WIDTH-1:0] intermediate;
    logic signed [WIDTH-1:0] temp_x_in;

    // Combinational block for intermediate calculation
    always_comb begin
        intermediate = 
            (a1 * y_prev1_o) +
            (a2 * y_prev2_o) +
            (b0 * temp_x_in) +
            (b1 * x_prev1_o) +
            (b2 * x_prev2_o);
    end

    // Sequential logic for filter operation
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            x_prev1_o <= 0;
            x_prev2_o <= 0;
            y_prev1_o <= 0;
            y_prev2_o <= 0;
            y_out_o <= 0;
            ntf_out_o <= 0;
            temp_x_in <= 0;
        end else begin
            temp_x_in <= x_in_i;
            x_prev2_o <= x_prev1_o;
            x_prev1_o <= temp_x_in;
            y_prev2_o <= y_prev1_o;
            y_prev1_o <= y_out_o;

            y_out_o <= intermediate;

            if (intermediate != 0) begin
                ntf_out_o <= ((1 << WIDTH) - intermediate) / intermediate;
            end else begin
                ntf_out_o <= 0;
            end
        end
    end

endmodule
