// Module name: SwitchingBlock
// Description: Implements switching logic with parameterizable data width and pseudorandom sequence handling.
// Date: 
// Version: 
// Author: 
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;
module SwitchingBlock  (
    input  logic                  clk_i,                                  // Clock signal
    input  logic                  reset_i,                                // Reset signal
    input  logic signed[WIDTH-1:0]      x_in_i,                                 // Input signal x_n,r[k]
    input  logic                  pn_seq_i,                               // Pseudorandom PN sequence (1-bit)
    input  logic signed[WIDTH-1:0]      quantized_value_i,                      // Quantizer input
    output logic signed[WIDTH-1:0]      x_out1_o,                               // Output x_n-1,2r-1[k]
    output logic signed[WIDTH-1:0]      x_out2_o                                // Output x_n-1,2r[k]
   
);
    // Internal signals for temporary values
	 logic signed [WIDTH:0] temp_x_out1;                                        // Temporary value for x_out1_o
    logic signed [WIDTH:0]   temp_x_out2;                                          // Temporary value for x_out2_o
    logic signed [WIDTH-1:0] temp_s;                                             // Temporary value for switching sequence
	 logic signed [WIDTH-1:0] s_out_o;                                            // Switching sequence s_n,r[k]
    // Continuous assignment for `temp_s_out` based on conditions
    assign temp_s = quantized_value_i ;
    assign s_out_o = (x_in_i[0]) ? (temp_s | 16'b0000_0000_0000_0001) : (temp_s & ~16'b0000_0000_0000_0001);
    // Continuous assignments for x_out1_o and x_out2_o
	 assign temp_x_out1 = (x_in_i + s_out_o)/16'b0000000000000010;                         // Divide input proportionally
    assign temp_x_out2 = x_in_i - temp_x_out1;                            // Complementary split
    // Sequential logic to update outputs
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset all outputs
            x_out1_o <= 16'b0;
            x_out2_o <= 16'b0;
        end else begin
            // Update x_out1_o and x_out2_o based on pn_seq_i
            if (pn_seq_i) begin
                x_out1_o <= temp_x_out1[WIDTH-1:0];
                x_out2_o <= temp_x_out2[WIDTH-1:0];
            end else begin
                x_out1_o <= temp_x_out2[WIDTH-1:0];                       // Swap assignments for pn_seq_i == 0
                x_out2_o <= temp_x_out1[WIDTH-1:0];
            end
        end
    end
endmodule