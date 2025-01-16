// Module name: quantizer
// Description: Implements quantizer logic with parameterizable input width, output width, and quantization functionality.
// Date: 
// Version: 1.0
// Author: 

module quantizer #(
    parameter INPUT_WIDTH = 16,     // Width of input signal
    parameter OUTPUT_WIDTH = 3      // Width of quantized output (3-bit quantizer in this case)
)(
    input  logic [INPUT_WIDTH-1:0]  x_in_i,           // Input signal
    input  logic [INPUT_WIDTH-1:0]  ntf_in_i,         // Noise Transfer Function (NTF) input
    input  logic                    clk_i,             // Clock input
    input  logic                    rst_i,             // Reset input (active high)
    output logic [OUTPUT_WIDTH-1:0] quantized_out_o,   // Quantized output
    output logic signed [INPUT_WIDTH-1:0] quant_error_o // Quantization error
);

    // Parameters for quantization levels
    localparam QUANT_STEP = (1 << (INPUT_WIDTH - OUTPUT_WIDTH)); // Step size
    localparam MAX_LEVEL  = (1 << OUTPUT_WIDTH) - 1;            // Maximum quantized level

    // Temporary registers for intermediate calculations
    logic [INPUT_WIDTH-1:0] preprocessed_input;    // Preprocessed input after shifting
    logic [INPUT_WIDTH-1:0] adjusted_input;        // Input adjusted by the NTF
    logic [INPUT_WIDTH-1:0] quant_value_FF;        // Final quantized value before clamping

    // Always block for quantization and error calculation
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            // Reset output signals
            quantized_out_o <= 0;
            quant_error_o   <= 0;
        end else begin
            // Step 1: Preprocess the input signal (right shift by 1)
            preprocessed_input = x_in_i >>> 1; // Arithmetic right shift by 1

            // Step 2: Adjust the input using the Noise Transfer Function (NTF)
            adjusted_input = preprocessed_input + ntf_in_i;

            // Step 3: Perform quantization (round to nearest quantization level)
            quant_value_FF = (adjusted_input + (QUANT_STEP >>> 1)) / QUANT_STEP;

            // Step 4: Clamp the quantized value within the range [0, MAX_LEVEL]
            if (quant_value_FF > MAX_LEVEL) begin
                quantized_out_o = MAX_LEVEL;
            end else if (quant_value_FF < 0) begin
                quantized_out_o = 0; // Clamping for negative values
            end else begin
                quantized_out_o = quant_value_FF[OUTPUT_WIDTH-1:0]; // Truncate to output width
            end

            // Step 5: Calculate quantization error
            quant_error_o = adjusted_input - (quantized_out_o * QUANT_STEP); 
        end
    end

endmodule
