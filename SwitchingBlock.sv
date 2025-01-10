
// Module name: SwitchingBlock
// Description: Switching logic with parameterizable data width and pseudorandom sequence handling
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
	 input  logic [WIDTH-1:0] quantized_value,   // quantizer input
    output logic [WIDTH-1:0]      x_out1_o,     // Output x_n-1,2r-1[k]
    output logic [WIDTH-1:0]      x_out2_o,     // Output x_n-1,2r[k]
    output logic [WIDTH-1:0]      s_out_o       // Switching sequence s_n,r[k]
);

    // Internal signals
    logic [WIDTH-1:0] loop_filter_output;  // Output of the loop filter
    //logic [WIDTH-1:0] quantized_value;     // Quantizer output
    logic [WIDTH-1:0] temp_s;              // Temporary switching sequence
    logic [WIDTH-1:0] temp_s_out;      	 // Temporary register for s_out


    // Generate switching sequence - Sequential
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            s_out_o <= 0;
        end else begin
            temp_s = quantized_value ^ {{(WIDTH-1){1'b0}}, pn_seq_i}; // XOR with PN sequence
            if (x_in_i[0]) begin
                // Input is odd, enforce odd switching sequence
                temp_s_out = temp_s | 1'b1;
            end else begin
                // Input is even, enforce even switching sequence
                temp_s_out = temp_s & ~1'b1;
            end

            // Update s_out with the new value
            s_out_o <= temp_s_out;
        end
    end

    // Compute x_out1 and x_out2 based on temp_s_out
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            x_out1_o <= 0;
            x_out2_o <= 0;
        end else begin
            if (pn_seq_i) begin
                x_out1_o <= x_in_i + temp_s_out; // Add the temporary switching sequence
                x_out2_o <= x_in_i - temp_s_out; // Subtract the temporary switching sequence
            end else begin
                x_out1_o <= x_in_i - temp_s_out; // Subtract the temporary switching sequence
                x_out2_o <= x_in_i + temp_s_out; // Add the temporary switching sequence
            end
        end
    end

endmodule