// Module name: SwitchingBlock
// Description: Switching logic with parameterizable data width and pseudorandom sequence handling
// Date: 
// Version: 
// Author: 

module SwitchingBlock #(
    parameter WIDTH = 8  // Parameterizable data width
) (
    input  logic                  clk_i,                  // Clock signal
    input  logic                  reset_i,                // Reset signal
    input  logic [WIDTH-1:0]      x_in_i,                 // Input signal x_n,r[k]
    input  logic [WIDTH-1:0]      loop_filter_value_i,    // Input from the loop filter
    input  logic                  pn_seq_i,               // Pseudorandom PN sequence (1-bit)
    output logic [WIDTH-1:0]      x_out1_o,               // Output x_n-1,2r-1[k]
    output logic [WIDTH-1:0]      x_out2_o,               // Output x_n-1,2r[k]
    output logic [WIDTH-1:0]      s_out_o                 // Switching sequence s_n,r[k]
);

    // Internal signal for temporary switching sequence
    logic [WIDTH-1:0] temp_s_FF;
    logic [WIDTH-1:0] quantized_value; // Quantizer output

    // Quantizer logic: Ensure range (0 to 2^(WIDTH-1))
    always_comb begin
        quantized_value = loop_filter_value_i % (1 << (WIDTH - 1)); // Ensure range is within 0 to 2^(WIDTH-1) - 1
    end

    // Main logic block
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            // Reset outputs to zero
            x_out1_o <= '0;
            x_out2_o <= '0;
            s_out_o  <= '0;
        end else begin
            // Generate switching sequence s_n,r[k]
            // XOR logic with quantized value and PN sequence
            temp_s_FF = quantized_value ^ {WIDTH-1'b0, pn_seq_i}; // Extend PN sequence to WIDTH
            
            // Ensure parity rules
            if (x_in_i[0]) begin
                // If input is odd, enforce odd switching sequence
                s_out_o <= temp_s_FF | 1'b1;
            end else begin
                // If input is even, enforce even switching sequence
                s_out_o <= temp_s_FF & ~(1'b1);
            end

            // Calculate outputs based on PN sequence
            if (pn_seq_i) begin
                x_out1_o <= x_in_i + s_out_o;  // Add switching sequence to input
                x_out2_o <= x_in_i - s_out_o;  // Subtract switching sequence from input
            end else begin
                x_out1_o <= x_in_i - s_out_o;  // Subtract switching sequence from input
                x_out2_o <= x_in_i + s_out_o;  // Add switching sequence to input
            end

            // Ensure outputs obey the number conservation rule and range
            if (x_out1_o > (1 << (WIDTH - 1)) - 1) begin
                x_out1_o <= (1 << (WIDTH - 1)) - 1;
            end

            if (x_out2_o > (1 << (WIDTH - 1)) - 1) begin
                x_out2_o <= (1 << (WIDTH - 1)) - 1;
            end
        end
    end

endmodule
