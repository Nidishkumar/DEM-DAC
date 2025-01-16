// Module name: TopModule
// Description: Combines various submodules including pn_sequence_generator, quantizer,
//              SecondOrderIIRNotchFilter, and SwitchingBlock to perform signal processing.
//              Processes input signals and provides filtered and switched outputs.
// Date: 
// Version: 1.0
// Author: 

module TopModule #(
    parameter INPUT_WIDTH = 16,    // Width of input signal
    parameter SWITCH_WIDTH = 5     // Width of switching block outputs
) (
    input  logic                  clk_i,       // Clock signal
    input  logic                  reset_i,     // Reset signal
    input  logic [INPUT_WIDTH-1:0] x_in_i,      // Input signal
    output logic [SWITCH_WIDTH-1:0] x_out1_o,   // Output from SwitchingBlock
    output logic [SWITCH_WIDTH-1:0] x_out2_o,   // Output from SwitchingBlock
    output logic [SWITCH_WIDTH-1:0] s_out_o     // Output from SwitchingBlock
);

    // Internal signals
    logic [INPUT_WIDTH-1:0] quant_out;        // Output of quantizer
    logic [INPUT_WIDTH-1:0] quant_error;      // Quantization error
    logic signed[INPUT_WIDTH-1:0] loop_filter_out;  // Output of SecondOrderIIRNotchFilter
    logic pn_seq;                            // Pseudorandom sequence signal

    // Instantiate pn_sequence_generator for generating random PN sequence
    pn_sequence_generator pn_gen_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .pn_seq_o(pn_seq)
    );

    // Instantiate quantizer
    quantizer #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(SWITCH_WIDTH)
    ) quantizer_inst (
        .x_in_i(x_in_i),                        // Input to quantizer (directly from x_in_i)
        .ntf_in_i(loop_filter_out),           // Connect loop filter output to NTF input
        .clk_i(clk_i),
        .rst_i(reset_i),
        .quantized_out_o(quant_out),
        .quant_error_o(quant_error)
    );

    // Instantiate SecondOrderIIRNotchFilter
    SecondOrderIIRNotchFilter #(
        .WIDTH(INPUT_WIDTH)
    ) loop_filter_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(quant_error),                   // Pass quantization error to loop filter
        .y_out_o(),
        .ntf_out_o(loop_filter_out),            // Noise Transfer Function output (unused)
        .x_prev1_o(),                           // Internal states (not connected)
        .x_prev2_o(),
        .y_prev1_o(),
        .y_prev2_o()
    );

    // Instantiate SwitchingBlock
    SwitchingBlock #(
        .WIDTH(SWITCH_WIDTH)
    ) switching_block_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i[SWITCH_WIDTH-1:0]),      // Pass lower bits of x_in_i
        .pn_seq_i(pn_seq),                    // Use PN sequence for switching
        .quantized_value_i(quant_out[SWITCH_WIDTH-1:0]),
        .x_out1_o(x_out1_o),
        .x_out2_o(x_out2_o),
        .s_out_o(s_out_o)
    );

endmodule
