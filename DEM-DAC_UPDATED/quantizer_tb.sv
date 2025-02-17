// Module name: quantizer_tb
// Description: Testbench for the quantizer module. It simulates various input conditions and checks the quantizer's functionality.
// Date: 
// Version: 1.0
// Author:
//`include "quantizer.sv"
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;  
module quantizer_tb;                            
    // Inputs                            
    logic [INPUT_WIDTH-1:0] x_in_i;                                                               // Input signal
    logic [INPUT_WIDTH-1:0] ntf_in_i;                                                             // Noise Transfer Function (NTF) input
    logic clk_i;                                                                                  // Clock input
    logic rst_i;                                                                                  // Reset input
    // Outputs
    logic [OUTPUT_WIDTH-1:0] quantized_out_o;                                                     // Quantized output
    logic signed [INPUT_WIDTH-1:0] quant_error_o;                                                 // Quantization error
    // Instantiate the DUT (Device Under Test)                            
    quantizer i_quantizer (                            
        .x_in_i(x_in_i),                                                                          // Connect input signal
        .ntf_in_i(ntf_in_i),                                                                      // Connect NTF input
        .clk_i(clk_i),                                                                            // Connect clock input
        .rst_i(rst_i),                                                                            // Connect reset input
        .quantized_out_o(quantized_out_o),                                                        // Connect output signal
        .quant_error_o(quant_error_o)                                                             // Connect quantization error output
    );                            
    // Clock generation (10ns period, 50% duty cycle)                            
    initial begin                            
        clk_i = 0;                            
    end                            
    always #5 clk_i = ~clk_i;                                                                     // Toggle clock every 5ns
    // Testbench procedure                            
    initial begin                            
        // Initialize inputs
        rst_i = 1;
        x_in_i = 0;
        ntf_in_i = 0;
        // Apply reset
        #10 rst_i = 0;
        // Test Case 1: Minimum input with zero NTF
        x_in_i = 16'd0;
        ntf_in_i = 16'd0;
        #10;
        $display("TC1: x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);       
        // Test Case 2: Mid-level input with non-zero NTF
        x_in_i = 16'd32768;                                                                      // Mid-level input (half of the maximum value)
        ntf_in_i = 16'd1024;                                                                     // A moderate NTF value
        #10;
        $display("TC2: x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);
        // Test Case 3: Maximum input with maximum NTF
        x_in_i = 16'd65535;                                                                      // Maximum input
        ntf_in_i = 16'd8192;                                                                     // High NTF value
        #10;
        $display("TC3: x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);
        // Test Case 4: Input between quantization steps with moderate NTF
        x_in_i = 16'd16384;                                                                      // A value close to a quantization step boundary
        ntf_in_i = 16'd4096;                                                                     // Moderate NTF
        #10;
        $display("TC4: x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);
        // Test Case 5: Edge case near a rounding boundary with small NTF
        x_in_i = 16'd8191;                                                                       // Just below QUANT_STEP boundary
        ntf_in_i = 16'd512;                                                                      // Small NTF value
        #10;
        $display("TC5: x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);
        // Test Case 6: Reset test
        rst_i = 1;
        #10 rst_i = 0;
        x_in_i = 16'd12345;                                                                      // Random input after reset
        ntf_in_i = 16'd256;                                                                      // Random NTF value after reset
        #10;
        $display("TC6: After reset, x_in = %d, ntf_in = %d, quantized_out = %d, quant_error = %d", 
                 x_in_i, ntf_in_i, quantized_out_o, quant_error_o);
        // Finish simulation
        #20;
        $finish;
    end
endmodule
