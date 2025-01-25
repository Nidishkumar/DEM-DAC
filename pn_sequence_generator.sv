// Module name: pn_sequence_generator
// Description: Generates a Pseudo-Random Noise (PN) sequence using an 8-bit Linear Feedback Shift Register (LFSR).
//              The LFSR uses taps at positions 7 and 5 for feedback.
// Date: 
// Version: 1.0
// Author: 
//`include "lib_switchblock_pkg.sv"
 
module pn_sequence_generator (
    input logic clk_i,          // Clock input
    input logic reset_i,        // Reset input (active high)
    output logic pn_seq_o       // Output Pseudo-Random Noise (PN) sequence bit
);

    // Internal 8-bit Linear Feedback Shift Register (LFSR)
    logic [7:0] lfsr;

    // LFSR logic: Shift and feedback based on taps at positions 7 and 5
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            lfsr <= 8'hFF;  // Initialize LFSR with a non-zero value on reset
        end else begin
            // Shift the LFSR and apply feedback XOR at positions 7 and 5
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};  // Shift and generate new bit
        end
    end

    // Output the most significant bit (MSB) of the LFSR as the PN sequence bit
    assign pn_seq_o = lfsr[7];

endmodule
