// Module name: quantizer
// Description: Parameterized quantizer module with input preprocessing and noise transfer function (NTF)
// Date: 
// Version: 
// Author: 

module quantizer #(
    parameter INPUT_WIDTH = 16,     // Width of input signal
    parameter OUTPUT_WIDTH = 3      // Width of quantized output (3-bit quantizer in this case)
)(
    input  logic [INPUT_WIDTH-1:0]  x_in_i,          // Input signal
    input  logic [INPUT_WIDTH-1:0]  ntf_in_i,        // Noise Transfer Function (NTF) input
    input  logic                    clk_i,          // Clock input
    input  logic                    rst_i,          // Reset input (active high)
    output logic [OUTPUT_WIDTH-1:0] quantized_out_o, // Quantized output
    output logic [INPUT_WIDTH-1:0]  quant_error_o    // Quantization error
);

    // Parameters for quantization levels
    localparam QUANT_STEP = (1 << (INPUT_WIDTH - OUTPUT_WIDTH)); // Step size
    localparam MAX_LEVEL  = (1 << OUTPUT_WIDTH) - 1;            // Maximum quantized level

    // Temporary registers for intermediate calculations
    logic [INPUT_WIDTH-1:0] preprocessed_input;
    logic [INPUT_WIDTH-1:0] adjusted_input;
    logic [INPUT_WIDTH-1:0] quant_value_FF;

    // Combined block for quantized output and quantization error
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            quantized_out_o <= '0;
            quant_error_o   <= '0;
        end else begin
            // Step 1: Preprocess the input (divide by 2)
            preprocessed_input = x_in_i >> 1; // Right shift by 1 to divide by 2

            // Step 2: Adjust input using the NTF input
            adjusted_input = preprocessed_input + ntf_in_i;

            // Step 3: Quantization logic (round to nearest quantized level)
            quant_value_FF = (adjusted_input + (QUANT_STEP >> 1)) / QUANT_STEP;

            // Step 4: Clamp the quantized value within range [0, MAX_LEVEL]
            if (quant_value_FF > MAX_LEVEL) begin
                quantized_out_o = MAX_LEVEL;
            end else begin
                quantized_out_o = quant_value_FF[OUTPUT_WIDTH-1:0];
            end

            // Step 5: Calculate quantization error
            quant_error_o = adjusted_input - (quantized_out_o * QUANT_STEP);
        end
    end

endmodule
