module TopModule #(
    parameter INPUT_WIDTH = 16,    // Width of input signal
    parameter SWITCH_WIDTH = 5     // Width of switching block outputs
) (
    input  logic                  clk,       // Clock signal
    input  logic                  reset,     // Reset signal
    input  logic [INPUT_WIDTH-1:0] x_in,      // Input signal
    input  logic                  use_ntf,   // Control signal for input selection
    output logic [SWITCH_WIDTH-1:0] x_out1,   // Output from SwitchingBlock
    output logic [SWITCH_WIDTH-1:0] x_out2,   // Output from SwitchingBlock
    output logic [SWITCH_WIDTH-1:0] s_out     // Output from SwitchingBlock
);

    // Internal signals
    logic [INPUT_WIDTH-1:0] quant_input;      // Selected input to quantizer
    logic [INPUT_WIDTH-1:0] quant_out;        // Output of quantizer
    logic [INPUT_WIDTH-1:0] quant_error;      // Quantization error
    logic [INPUT_WIDTH-1:0] loop_filter_out;  // Output of SecondOrderIIRNotchFilter
    logic pn_seq;                            // Pseudorandom sequence signal

    // Input selection logic
    assign quant_input = use_ntf ? loop_filter_out : x_in;

    // Instantiate pn_sequence_generator for generating random PN sequence
    pn_sequence_generator pn_gen_inst (
        .clk(clk),
        .reset(reset),
        .pn_seq(pn_seq)
    );

    // Instantiate quantizer
    quantizer #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(SWITCH_WIDTH)
    ) quantizer_inst (
        .x_in_i(quant_input),
        .clk_i(clk),
        .rst_i(reset),
        .quantized_out_o(quant_out),
        .quant_error_o(quant_error)
    );

    // Instantiate SecondOrderIIRNotchFilter
    SecondOrderIIRNotchFilter #(
        .WIDTH(INPUT_WIDTH)
    ) loop_filter_inst (
        .clk(clk),
        .reset(reset),
        .x_in(quant_error),
        .y_out(loop_filter_out),
        .ntf_out(),        // Noise Transfer Function output (unused in this case)
        .x_prev1(),        // Internal states (not connected)
        .x_prev2(),
        .y_prev1(),
        .y_prev2()
    );

    // Instantiate SwitchingBlock
    SwitchingBlock #(
        .WIDTH(SWITCH_WIDTH)
    ) switching_block_inst (
        .clk_i(clk),
        .reset_i(reset),
        .x_in_i(x_in[SWITCH_WIDTH-1:0]),      // Pass lower bits of x_in
        .pn_seq_i(pn_seq),                    // Use PN sequence for switching
        .quantized_value(quant_out[SWITCH_WIDTH-1:0]),
        .x_out1_o(x_out1),
        .x_out2_o(x_out2),
        .s_out_o(s_out)
    );

endmodule
