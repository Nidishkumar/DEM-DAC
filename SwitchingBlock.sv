// Module name: SwitchingBlock
// Description: Implements switching logic with parameterizable data width and pseudorandom sequence handling.
// Date: 
// Version: 
// Author: 
`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;

module SwitchingBlock (
    input  logic                  clk_i,        // Clock signal
    input  logic                  reset_i,      // Reset signal
    input  logic [WIDTH-1:0]      x_in_i,       // Input signal x_n,r[k]
    input  logic                  pn_seq_i,     // Pseudorandom PN sequence (1-bit)
    input  logic [WIDTH-1:0]      quantized_value_i, // Quantizer input
    output logic [WIDTH-1:0]      x_out1_o,     // Output x_n-1,2r-1[k]
    output logic [WIDTH-1:0]      x_out2_o,     // Output x_n-1,2r[k]
    output logic [WIDTH-1:0]      s_out_o       // Switching sequence s_n,r[k]
);

    // Internal signals
    logic [WIDTH-1:0] temp_s;          // Temporary switching sequence
    logic [WIDTH-1:0] temp_s_out;      // Temporary register for s_out

    // Generate switching sequence
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            s_out_o <= 0;
        end else begin
            temp_s <= quantized_value_i ^ {{(WIDTH-1){1'b0}}, pn_seq_i};
            if (x_in_i[0]) begin
                temp_s_out <= temp_s | 1'b1;
            end else begin
                temp_s_out <= temp_s & ~1'b1;
            end
            s_out_o <= temp_s_out;
        end
    end

    // Compute x_out1_o and x_out2_o
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            x_out1_o <= 0;
            x_out2_o <= 0;
        end else begin
            if (pn_seq_i) begin
                x_out1_o <= x_in_i + temp_s_out;
                x_out2_o <= x_in_i - temp_s_out;
            end else begin
                x_out1_o <= x_in_i - temp_s_out;
                x_out2_o <= x_in_i + temp_s_out;
            end
        end
    end

endmodule
