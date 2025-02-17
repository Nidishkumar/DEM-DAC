// Module name: tb_SwitchingBlock
// Description: Testbench for the SwitchingBlock module. Implements various test cases to verify the functionality of switching logic.
// Author: 
// Date: 
// Version: 

//`include "SwitchingBlock.sv"
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;  // Importing necessary package for switchblock functionality.

module tb_SwitchingBlock;
    // Testbench signals
    logic clk_i;                                                      // Clock signal
    logic reset_i;                                                    // Reset signal
    logic signed [WIDTH-1:0] x_in_i;                                  // Input signal for DUT
    logic pn_seq_i;                                                   // Pseudorandom PN sequence for DUT
    logic signed [WIDTH-1:0] quantized_value_i;                       // Quantized value input for DUT
    logic signed [WIDTH-1:0] x_out1_o;                                // Output 1 from DUT
    logic signed [WIDTH-1:0] x_out2_o;                                // Output 2 from DUT
    
    // DUT instantiation
    SwitchingBlock dut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .pn_seq_i(pn_seq_i),
        .quantized_value_i(quantized_value_i),
        .x_out1_o(x_out1_o),
        .x_out2_o(x_out2_o)
    );
    
    // Clock generation
    always #5 clk_i = ~clk_i; // Generate a clock signal with a period of 10ns
    
    // Task to display outputs
    task print_outputs;
        begin
            $display("clk_i: %b | reset_i: %b | x_in_i: %d | pn_seq_i: %b | quantized_value_i: %d | x_out1_o: %d | x_out2_o: %d",
                      clk_i, reset_i, x_in_i, pn_seq_i, quantized_value_i, x_out1_o, x_out2_o);
        end
    endtask
    
    // Testbench procedure
    initial begin
        // Initialize inputs
        clk_i = 0;
        reset_i = 1;
        x_in_i = 0;
        pn_seq_i = 0;
        quantized_value_i = 0;
        
        #5 reset_i = 0; // Deassert reset
        
        // Test cases
          #20 quantized_value_i = 0; x_in_i = -3; pn_seq_i = 1; #10 print_outputs();
          #20 quantized_value_i = 0; x_in_i = -5; pn_seq_i = 0; #10 print_outputs();
          #20 quantized_value_i = 4; x_in_i = 4; pn_seq_i = 1; #10 print_outputs();
          #20 quantized_value_i = 6; x_in_i = 6; pn_seq_i = 0; #10 print_outputs();
          #20 quantized_value_i = 7; x_in_i = 7; pn_seq_i = 1; #10 print_outputs();
          #20 quantized_value_i = 2; x_in_i = 9; pn_seq_i = 0; #10 print_outputs();
          #20 quantized_value_i = 1; x_in_i = 10; pn_seq_i = 1;#10 print_outputs();
          #20 quantized_value_i = 3; x_in_i = 12; pn_seq_i = 0;#10 print_outputs();
          #20 quantized_value_i = 0; x_in_i = 0; pn_seq_i = 1; #10 print_outputs();
          #20 quantized_value_i = 0; x_in_i = 0; pn_seq_i = 0; #10 print_outputs();
        
        // Reset Test
        #10 reset_i = 1;#10 print_outputs();
        #10 reset_i = 0;#10 print_outputs();
        
        // End simulation
        #10 $finish;
    end
endmodule
