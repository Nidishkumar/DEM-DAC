// Module name: quantizer
// Description: Parameterized quantizer module for rounding inputs to nearest quantization levels with error calculation
// Date: 
// Version: 
// Author: 

module quantizer #(
    parameter INPUT_WIDTH = 16,     // Width of input signal
    parameter OUTPUT_WIDTH = 3      // Width of quantized output (3-bit quantizer in this case)
)(
    input  logic [INPUT_WIDTH-1:0]  x_in_i,          // Input signal
    input  logic                    clk_i,          // Clock input
    input  logic                    rst_i,          // Reset input (active high)
    output logic [OUTPUT_WIDTH-1:0] quantized_out_o, // Quantized output
    output logic [INPUT_WIDTH-1:0]  quant_error_o    // Quantization error
);
    // Parameters for quantization levels
    localparam QUANT_STEP = (1 << (INPUT_WIDTH - OUTPUT_WIDTH)); // Step size
    localparam MAX_LEVEL  = (1 << OUTPUT_WIDTH) - 1;            // Maximum quantized level

    // Temporary registers for intermediate calculations
    logic [INPUT_WIDTH-1:0] quant_value_FF;

    // Combined block for quantized output and quantization error
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            quantized_out_o <= '0;
            quant_error_o   <= '0;
        end else begin
            // Quantization logic: round input to nearest quantized level
            quant_value_FF = (x_in_i + (QUANT_STEP >> 1)) / QUANT_STEP;

            // Clamp the quantized value within range [0, MAX_LEVEL]
            if (quant_value_FF > MAX_LEVEL) begin
                quantized_out_o = MAX_LEVEL;
            end else begin
                quantized_out_o = quant_value_FF[OUTPUT_WIDTH-1:0];
            end

            // Calculate quantization error using the updated quantized_out
            quant_error_o = x_in_i - (quantized_out_o * QUANT_STEP);
        end
    end

endmodule
