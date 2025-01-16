// Module name: tb_pn_sequence_generator
// Description: Testbench for the PN sequence generator module.
//              Applies stimulus to the pn_sequence_generator and monitors its output.
// Date:
// Version: 1.0
// Author: 

module tb_pn_sequence_generator;

    // Testbench signals
    logic clk_i;      // Clock input
    logic reset_i;    // Reset input
    logic pn_seq_o;   // Output PN sequence bit

    // Instantiate the pn_sequence_generator module
    pn_sequence_generator pn_gen_inst (
        .clk_i(clk_i),        // Connect input clock
        .reset_i(reset_i),    // Connect input reset
        .pn_seq_o(pn_seq_o)   // Connect output PN sequence bit
    );

    // Clock generation (50 MHz clock)
    always begin
        #10 clk_i = ~clk_i;  // Toggle clock every 10ns for a 50MHz clock
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 0; 
        
        // Apply reset
        $display("Applying reset...");
        reset_i = 1;
        #20;  // Hold reset for two clock cycles
        reset_i = 0;
        
        // Monitor the pn_seq_o output for 100 clock cycles
        $display("Starting simulation...");
        $monitor("At time %t, pn_seq_o = %b", $time, pn_seq_o);
        
        #200;  // Simulate for 200ns (20 clock cycles)
        
        $display("Simulation complete.");
        $finish;
    end

endmodule
