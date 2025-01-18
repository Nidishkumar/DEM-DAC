// Package: lib_switchblock_pkg
// Description: Centralized storage for parameters and constants used across design modules
// Date: 
// Version: 1.0
// Author: 

package lib_switchblock_pkg;

    // Parameter definitions
    parameter  INPUT_WIDTH = 16;          // Default input width
    parameter  OUTPUT_WIDTH = 3;         // Default output width for quantizer
    parameter  SWITCH_WIDTH = 5;         // Default width for switching block outputs
    parameter  WIDTH = 16;                // Default width for various modules

    // Coefficients for SecondOrderIIRNotchFilter
    parameter logic signed [INPUT_WIDTH-1:0] B0 = 16'sd32768;
    parameter logic signed [INPUT_WIDTH-1:0] B1 = -16'sd62325;
    parameter logic signed [INPUT_WIDTH-1:0] B2 = 16'sd32768;
    parameter logic signed [INPUT_WIDTH-1:0] A1 = -16'sd61702;
    parameter logic signed [INPUT_WIDTH-1:0] A2 = 16'sd32116;

    // Quantization constants
    parameter  QUANT_STEP = (1 << (INPUT_WIDTH - OUTPUT_WIDTH)); // Step size
    parameter  MAX_LEVEL  = (1 << OUTPUT_WIDTH) - 1;            // Maximum quantized level

    // Pseudo-random noise generator constants
    parameter  LFSR_INIT = 8'hFF;          // Initial LFSR value
    parameter  LFSR_TAPS = 2'b11;   // Tap positions (7 and 5)

endpackage

