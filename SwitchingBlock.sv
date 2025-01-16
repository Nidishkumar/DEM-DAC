// Module name: SwitchingBlock
// Description: Implements switching logic with parameterizable data width and pseudorandom sequence handling.
// Date: 
// Version: 
// Author: 

module SwitchingBlock #(
    parameter WIDTH = 5  // Fixed width for the design
) (
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

    // Generate switching sequence - Sequential logic
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            s_out_o <= 0; // Reset output to zero
        end else begin
            // Generate temporary switching sequence by XOR with PN sequence
            temp_s = quantized_value_i ^ {{(WIDTH-1){1'b0}}, pn_seq_i};
            
            // Enforce odd or even switching sequence based on input
            if (x_in_i[0]) begin
                temp_s_out = temp_s | 1'b1; // Odd switching sequence
            end else begin
                temp_s_out = temp_s & ~1'b1; // Even switching sequence
            end

            // Update switching sequence output
            s_out_o <= temp_s_out;
        end
    end

    // Compute x_out1_o and x_out2_o based on temp_s_out
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            x_out1_o <= 0; // Reset output 1 to zero
            x_out2_o <= 0; // Reset output 2 to zero
        end else begin
            if (pn_seq_i) begin
                x_out1_o <= x_in_i + temp_s_out; // Add the switching sequence
                x_out2_o <= x_in_i - temp_s_out; // Subtract the switching sequence
            end else begin
                x_out1_o <= x_in_i - temp_s_out; // Subtract the switching sequence
                x_out2_o <= x_in_i + temp_s_out; // Add the switching sequence
            end
        end
    end

endmodule
