module pn_sequence_generator (
    input logic clk,
    input logic reset,
    output logic pn_seq
);
    logic [7:0] lfsr;  // 8-bit LFSR for simplicity

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'hFF;  // Initialize LFSR with a non-zero value
        end else begin
            // Example taps for the LFSR: Tap positions at 7 and 5
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};  // Shift and generate new bit
        end
    end

    assign pn_seq = lfsr[7];  // Output the MSB as the PN sequence bit
endmodule
