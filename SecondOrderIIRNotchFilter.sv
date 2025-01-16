// Module name: SecondOrderIIRNotchFilter
// Description: Implements a second-order IIR notch filter using a difference equation.
//              Provides filtering with specified coefficients and computes the NTF.
// Date: 
// Version: 1.0
// Author: 

module SecondOrderIIRNotchFilter #(
    parameter WIDTH = 16  // Bit width of the signals and coefficients
)(
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
    logic signed [WIDTH-1:0] temp_x_in;
    logic signed [4*WIDTH-1:0] temp_y_out;
    logic signed [4*WIDTH-1:0] intermediate;

    // Sequential logic for filter operation
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset all states and outputs to zero
            x_prev1_o <= 0;
            x_prev2_o <= 0;
            y_prev1_o <= 0;
            y_prev2_o <= 0;
            y_out_o <= 0;
            ntf_out_o <= 0;
        end else begin
            // Step 1: Shift previous input and output values
            x_prev2_o <= x_prev1_o;
            x_prev1_o <= x_in_i;
            y_prev2_o <= y_prev1_o;
            y_prev1_o <= y_out_o;

            // Step 2: Compute the intermediate output using the difference equation
            intermediate = 
                (a1 * y_prev1_o) +
                (a2 * y_prev2_o) +
                (b0 * x_in_i) +
                (b1 * x_prev1_o) +
                (b2 * x_prev2_o);

            // Step 3: Assign the calculated output
            y_out_o <= intermediate;

            // Step 4: Calculate Noise Transfer Function (NTF) output
            if (intermediate != 0) begin
                ntf_out_o <= ((1 << WIDTH) - intermediate) / intermediate; // NTF = (1 - H(z)) / H(z)
            end else begin
                ntf_out_o <= 0; // Default to zero if division by zero
            end
        end
    end
endmodule
