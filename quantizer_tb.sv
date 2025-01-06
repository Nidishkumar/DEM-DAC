// Module name: quantizer_tb
// Description: Testbench for the quantizer module to verify functionality with various test cases.
// Date: 
// Version: 
// Author: 

`timescale 1ns / 1ps

module quantizer_tb;

    // Parameters
    parameter INPUT_WIDTH = 16; // Width of input signal
    parameter OUTPUT_WIDTH = 3; // Width of quantized output

    // Inputs
    logic [INPUT_WIDTH-1:0] x_in_i;      // Input signal
    logic                   clk_i;      // Clock input
    logic                   rst_i;      // Reset input

    // Outputs
    logic [OUTPUT_WIDTH-1:0] quantized_out_o; // Quantized output
    logic [INPUT_WIDTH-1:0]  quant_error_o;   // Quantization error

    // Instantiate the DUT (Device Under Test)
    quantizer #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH)
    ) i_quantizer (
        .x_in_i(x_in_i),
        .clk_i(clk_i),
        .rst_i(rst_i),
        .quantized_out_o(quantized_out_o),
        .quant_error_o(quant_error_o)
    );

    // Clock generation (10ns period, 50% duty cycle)
    initial begin
        clk_i = 0;
    end
    always #5 clk_i = ~clk_i;

    // Testbench procedure
    initial begin
        // Initialize inputs
        rst_i = 1;
        x_in_i = 0;

        // Apply reset
        #10 rst_i = 0;

        // Test Case 1: Minimum input
        x_in_i = 16'd0;
        #10;
        $display("TC1: x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Test Case 2: Mid-level input
        x_in_i = 16'd32768;
        #10;
        $display("TC2: x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Test Case 3: Maximum input
        x_in_i = 16'd65535;
        #10;
        $display("TC3: x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Test Case 4: Between quantization steps
        x_in_i = 16'd16384; // QUANT_STEP * 2
        #10;
        $display("TC4: x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Test Case 5: Edge case near a rounding boundary
        x_in_i = 16'd8191; // Just below QUANT_STEP
        #10;
        $display("TC5: x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Test Case 6: Reset test
        rst_i = 1;
        #10 rst_i = 0;
        x_in_i = 16'd12345;
        #10;
        $display("TC6: After reset, x_in = %d, quantized_out = %d, quant_error = %d", x_in_i, quantized_out_o, quant_error_o);

        // Finish simulation
        #20;
        $stop;
    end

endmodule
