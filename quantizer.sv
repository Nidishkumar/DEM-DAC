// Module name: Quantizer
// Description: Implements quantizer logic with parameterizable input width, output width, and quantization functionality.
// Date: 
// Version: 1.0
// Author: 

import lib_switchblock_pkg::*;  // Importing necessary package for switchblock functionality.

module quantizer (
    input  logic [INPUT_WIDTH-1:0]  x_in_i,           // Input signal (x)
    input  logic [INPUT_WIDTH-1:0]  ntf_in_i,         // Noise Transfer Function (NTF) input
    input  logic                    clk_i,            // Clock input
    input  logic                    rst_i,            // Reset input (active high)
    output logic [OUTPUT_WIDTH-1:0] quantized_out_o,  // Quantized output signal
    output logic signed [INPUT_WIDTH-1:0] quant_error_o // Quantization error signal
);

    // Local parameters for quantization process
    // QUANT_STEP determines the quantization step size based on the difference between input and output width
    localparam QUANT_STEP = (1 << (INPUT_WIDTH - OUTPUT_WIDTH));  
    // MAX_LEVEL defines the maximum level of quantized output
    localparam MAX_LEVEL  = (1 << OUTPUT_WIDTH) - 1;   

    // Intermediate registers for processing signals
    logic [INPUT_WIDTH-1:0] preprocessed_input;    // Preprocessed input after scaling
    logic [INPUT_WIDTH-1:0] adjusted_input;        // Input adjusted by adding NTF
    logic [INPUT_WIDTH-1:0] quant_value_FF;       // Temporary register for quantization calculation

    // Quantization logic with error calculation
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            // Reset outputs and intermediate registers
            quantized_out_o <= 0;
            quant_error_o   <= 0;
        end else begin
            // Quantization process
            // Step 1: Preprocess the input signal by right-shifting (scaling down)
            preprocessed_input <= x_in_i >>> 1;

            // Step 2: Adjust the preprocessed input by adding the Noise Transfer Function (NTF)
            adjusted_input <= preprocessed_input + ntf_in_i;

            // Step 3: Calculate quantized value based on the adjusted input and quantization step
            quant_value_FF <= (adjusted_input + (QUANT_STEP >>> 1)) / QUANT_STEP;  // Rounding logic

            // Step 4: Ensure the quantized output stays within bounds
            if (quant_value_FF > MAX_LEVEL) begin
                quantized_out_o <= MAX_LEVEL;  // Cap at the maximum output level
            end else if (quant_value_FF < 0) begin
                quantized_out_o <= 0;  // Floor at zero
            end else begin
                quantized_out_o <= quant_value_FF[OUTPUT_WIDTH-1:0];  // Assign quantized value
            end

            // Step 5: Calculate quantization error as the difference between adjusted input and the quantized output
            quant_error_o <= adjusted_input - (quantized_out_o * QUANT_STEP);
        end
    end

endmodule
