import lib_switchblock_pkg::*;  // Import package for switch block functionality

module quantizer (
    input  logic signed [INPUT_WIDTH-1:0]  x_in_i,         // Signed input signal
    input  logic signed [INPUT_WIDTH-1:0]  ntf_in_i,       // Signed Noise Transfer Function (NTF) input
    input  logic                           clk_i,          // Clock input
    input  logic                           rst_i,          // Reset input (active high)
    output logic signed [INPUT_WIDTH-1:0]  quantized_out_o, // Signed quantized output signal
    output logic signed [INPUT_WIDTH-1:0]  quant_error_o   // Signed quantization error signal
);

    // Intermediate signals for processing
    logic signed [INPUT_WIDTH-1:0] preprocessed_input; // Preprocessed input after scaling
    logic signed [INPUT_WIDTH-1:0] adjusted_input;     // Input adjusted with NTF
    logic signed [32:0]   quant_value_FF;     // Extra bit for overflow handling
    logic signed [32:0] quant_err;

    // Step 1: Preprocess the input by scaling it down (divide by 2)
    assign preprocessed_input = x_in_i >>> 1; // Arithmetic right shift retains sign
    
    // Step 2: Adjust the input with the NTF signal
    assign adjusted_input = preprocessed_input + ntf_in_i;

    // Step 3: Apply quantization rounding logic
    assign quant_value_FF = (adjusted_input + (QUANT_STEP >>> 1)) / QUANT_STEP;
    assign quant_err = adjusted_input - (quant_value_FF * QUANT_STEP);

    // Step 4: Quantization logic with saturation
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            quantized_out_o <= 0;
            quant_error_o   <= 0;
        end else begin
            // Ensure the quantized value stays within bounds
            if (quant_value_FF > MAX_LEVEL) begin
                quantized_out_o <= MAX_LEVEL[INPUT_WIDTH-1:0];
            end else if (quant_value_FF < 0) begin
                quantized_out_o <= 0;
            end else begin
                quantized_out_o <= quant_value_FF[INPUT_WIDTH-1:0];
            end
            
            // Step 5: Compute quantization error
            quant_error_o <= quant_err;
        end
    end

endmodule
