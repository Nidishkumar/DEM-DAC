module tb_TopModule;

    // Parameters
    parameter INPUT_WIDTH = 16;
    parameter SWITCH_WIDTH = 5;

    // Inputs to the DUT
    logic clk;
    logic reset;
    logic [INPUT_WIDTH-1:0] x_in;
    logic use_ntf;

    // Outputs from the DUT
    logic [SWITCH_WIDTH-1:0] x_out1;
    logic [SWITCH_WIDTH-1:0] x_out2;
    logic [SWITCH_WIDTH-1:0] s_out;

    // Instantiate the DUT (Device Under Test)
    TopModule #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .SWITCH_WIDTH(SWITCH_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .use_ntf(use_ntf),
        .x_out1(x_out1),
        .x_out2(x_out2),
        .s_out(s_out)
    );

    // Clock generation (100 MHz clock)
    always #5 clk = ~clk;  // Toggle every 5ns for 100 MHz

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        x_in = 16'sd0;
        use_ntf = 0;

        // Apply reset
        #10 reset = 0;  // Hold reset for 2 clock cycles
        #10 reset = 1;

        // Test Case 1: Step input signal with default NTF behavior
        x_in = 16'sd50;  // Step input signal
        use_ntf = 0;     // Use input signal directly
        #20; // Wait for a few clock cycles
        $display("Test Case 1 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 2: Apply NTF (Noise Transfer Function) output as input signal
        use_ntf = 1;     // Use NTF output from IIR filter
        #20;
        $display("Test Case 2 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 3: Zero input signal, verify outputs should be zero
        x_in = 16'sd0;   // Zero input signal
        use_ntf = 0;
        #20;
        $display("Test Case 3 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 4: Apply negative input signal
        x_in = -16'sd50; // Negative input signal
        use_ntf = 0;
        #20;
        $display("Test Case 4 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 5: Test with large positive value
        x_in = 16'sd200;  // Large positive input signal
        use_ntf = 1;      // Use NTF from loop filter
        #20;
        $display("Test Case 5 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 6: Apply edge case values for switching behavior
        x_in = 16'sd1000; // Test with larger input
        use_ntf = 0;
        #20;
        $display("Test Case 6 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 7: Testing reset behavior after input signal changes
        reset = 1;  // Assert reset again
        #10 reset = 0;  // Deassert reset
        x_in = 16'sd75;  // Apply input after reset
        use_ntf = 0;
        #20;
        $display("Test Case 7 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // Test Case 8: Test PN sequence behavior (SwitchingBlock input)
        use_ntf = 0;     // Direct input signal
        x_in = 16'sd60;
        #20;
        $display("Test Case 8 -> Input:%d, x_out1:%d, x_out2:%d, s_out:%d", x_in, x_out1, x_out2, s_out);

        // End of test
        $finish;
    end

endmodule
