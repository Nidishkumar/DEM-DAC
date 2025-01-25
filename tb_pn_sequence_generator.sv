// Testbench for PN_Sequence_Generator
// This testbench verifies the functionality of the PN sequence generator.

//`include "lib_switchblock_pkg.sv"
//`include "pn_sequence_generator"

module tb_pn_sequence_generator;

    // Testbench signals
    logic clk_tb;           // Clock signal
    logic reset_tb;         // Reset signal
    logic pn_seq_tb;        // PN sequence output

    // Instantiate the pn_sequence_generator module
    pn_sequence_generator uut (
        .clk_i(clk_tb),       // Connect the clock
        .reset_i(reset_tb),   // Connect the reset
        .pn_seq_o(pn_seq_tb)  // Connect the output
    );

    // Clock generation: 50 MHz clock
    always begin
        #10 clk_tb = ~clk_tb;  // Toggle clock every 10 ns (50 MHz)
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk_tb = 0;
        reset_tb = 0;
        
        // Apply reset
        $display("Applying reset...");
        reset_tb = 1;
        #20;  // Hold reset for 20 ns
        reset_tb = 0;
        
        // Observe the PN sequence for some clock cycles
        $display("Observing PN sequence output...");
        #100;  // Observe for 100 ns (5 clock cycles)

        // End the simulation
        $finish;
    end

    // Monitor the output
    initial begin
        $monitor("Time: %0t | pn_seq_o: %b", $time, pn_seq_tb);
    end

endmodule
