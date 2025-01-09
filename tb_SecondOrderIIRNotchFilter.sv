module tb_SecondOrderIIRNotchFilter;

    // Parameters
    parameter WIDTH = 16;

    // Inputs to the DUT
    logic clk;
    logic reset;
    logic signed [WIDTH-1:0] x_in;

    // Outputs from the DUT
    logic signed [2*WIDTH-1:0] y_out;
    logic signed [WIDTH-1:0] ntf_out;
    logic signed [WIDTH-1:0] x_prev1;
    logic signed [WIDTH-1:0] x_prev2;
    logic signed [WIDTH-1:0] y_prev1;
    logic signed [WIDTH-1:0] y_prev2;

    // Instantiate the DUT (Device Under Test)
    SecondOrderIIRNotchFilter #(
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y_out),
        .ntf_out(ntf_out),
        .x_prev1(x_prev1),
        .x_prev2(x_prev2),
        .y_prev1(y_prev1),
        .y_prev2(y_prev2)
    );
	 
	 

    // Clock generation (100 MHz clock)
   always         #5 clk = ~clk;    

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        x_in = 0;

        // Apply reset
        reset = 1;
        #10; // Hold reset for 2 clock cycles
        reset = 0;
        
        // Apply test vectors
        // Test case 1: Step input, constant value
        x_in = 16'sd50;
        #10; // Wait for 1 clock cycle
        $display("Test Case 1 -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);
        
        // Test case 2: Zero input
        x_in = 16'sd0;
        #10; // Wait for 1 clock cycle
        $display("Test Case 2 -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        // Test case 3: Positive input signal
        x_in = 16'sd20;
        #10; // Wait for 1 clock cycle
        $display("Test Case 3 -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        // Test case 4: Negative input signal
        x_in = -16'sd150;
        #10; // Wait for 1 clock cycle
        $display("Test Case 4 -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        // Test case 5: Alternating positive and negative inputs
        x_in = 16'sd100;
        #10; // Wait for 1 clock cycle
        $display("Test Case 5 (Positive Input) -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        x_in = -16'sd400;
        #10; // Wait for 1 clock cycle
        $display("Test Case 5 (Negative Input) -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        // Test case 6: High input signal
        x_in = 16'sd25;
        #10; // Wait for 1 clock cycle
        $display("Test Case 6 -> Input:%d, Output:%d, NTF:%d", x_in, y_out, ntf_out);
        $display("x_prev1:%d, x_prev2:%d", x_prev1, x_prev2);
        $display("y_prev1:%d, y_prev2:%d", y_prev1, y_prev2);

        // End of test
        $finish;
    end

endmodule


