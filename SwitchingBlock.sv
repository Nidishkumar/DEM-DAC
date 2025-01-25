// Module name: SwitchingBlock
// Description: Implements switching logic with parameterizable data width and pseudorandom sequence handling.
// Date: 
// Version: 
// Author: 
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;

module SwitchingBlock  (
    input  logic                  clk_i,        // Clock signal
    input  logic                  reset_i,      // Reset signal
    input  logic [WIDTH-1:0]      x_in_i,       // Input signal x_n,r[k]
    input  logic                  pn_seq_i,     // Pseudorandom PN sequence (1-bit)
    input  logic [WIDTH-1:0]      quantized_value_i, // Quantizer input
    output logic [WIDTH-1:0]      x_out1_o,     // Output x_n-1,2r-1[k]
    output logic [WIDTH-1:0]      x_out2_o,     // Output x_n-1,2r[k]
    output logic [WIDTH-1:0]      s_out_o       // Switching sequence s_n,r[k]
);

    // Internal signals for temporary values
    logic [WIDTH-1:0] temp_x_out1;   // Temporary value for x_out1_o
    logic [WIDTH-1:0] temp_x_out2;   // Temporary value for x_out2_o
    logic [WIDTH-1:0] temp_s;        // Temporary value for switching sequence
    logic [WIDTH-1:0] temp_s_out;    // Temporary value for s_out_o

    // Continuous assignment for `temp_s_out` based on conditions
    assign temp_s = quantized_value_i ;//^ {{(WIDTH-1){1'b0}}, pn_seq_i};
    assign temp_s_out = (x_in_i[0]) ? (temp_s | 16'b1) : (temp_s & ~16'b1);

    // Continuous assignments for x_out1_o and x_out2_o
    assign temp_x_out1 = x_in_i + temp_s_out;
    assign temp_x_out2 = x_in_i - temp_s_out;

    // Sequential logic to update outputs
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset all outputs
            s_out_o  <= '0;
            x_out1_o <= '0;
            x_out2_o <= '0;
        end else begin
            // Update s_out_o using temp_s_out
            s_out_o <= temp_s_out;

            // Update x_out1_o and x_out2_o based on pn_seq_i
            if (pn_seq_i) begin
                x_out1_o <= temp_x_out1;
                x_out2_o <= temp_x_out2;
            end else begin
                x_out1_o <= temp_x_out2; // Swap assignments for pn_seq_i == 0
                x_out2_o <= temp_x_out1;
            end
        end
    end

endmodule
