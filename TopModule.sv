// Module name: TopModule
// Description: Combines various submodules including pn_sequence_generator, quantizer,
//              SecondOrderIIRNotchFilter, and SwitchingBlock to perform signal processing.
// Date: 
// Version: 1.0
// Author: 
// Import required packages and include files
// `include "lib_switchblock_pkg.sv"
// `include "pn_sequence_generator.sv"
// `include "quantizer.sv"
// `include "SecondOrderIIRNotchFilter.sv"
// `include "SwitchingBlock.sv"
import lib_switchblock_pkg::*;
module TopModule (
    input  logic                  clk_i,                         // Clock signal
    input  logic                  reset_i,                       // Reset signal
    input  logic [INPUT_WIDTH-1:0] x_in_i,                       // Input signal
    output logic [INPUT_WIDTH-1:0] x_out1_o,                     // Output from SwitchingBlock
    output logic [INPUT_WIDTH-1:0] x_out2_o                      // Output from SwitchingBlock
);
    // Internal signals
    logic [INPUT_WIDTH-1:0] quant_out;                           // Output of quantizer
    logic [INPUT_WIDTH-1:0] quant_error;                         // Quantization error
    logic signed [INPUT_WIDTH-1:0] loop_filter_out;              // Output of SecondOrderIIRNotchFilter
    logic pn_seq;                                                // Pseudorandom sequence signal
    // Instantiate pn_sequence_generator
    pn_sequence_generator pn_gen_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .pn_seq_o(pn_seq)
    );
    // Instantiate quantizer
    quantizer quantizer_inst (
        .x_in_i(x_in_i),
        .ntf_in_i(loop_filter_out),
        .clk_i(clk_i),
        .rst_i(reset_i),
        .quantized_out_o(quant_out),
        .quant_error_o(quant_error)
    );
    // Instantiate SecondOrderIIRNotchFilter
    SecondOrderIIRNotchFilter loop_filter_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(quant_error),                
        .ntf_out_o(loop_filter_out)              
    );
    // Instantiate SwitchingBlock
    SwitchingBlock switching_block_inst (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .pn_seq_i(pn_seq),
        .quantized_value_i(quant_out),
        .x_out1_o(x_out1_o),
        .x_out2_o(x_out2_o)
        
    );
endmodule