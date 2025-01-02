module tb_SwitchingBlock;

    // Testbench parameters
    parameter WIDTH = 8;

    // Testbench signals
    logic clk_tb;
    logic reset_tb;
    logic [WIDTH-1:0] x_in_tb;
    logic [WIDTH-1:0] loop_filter_value_tb;
    logic pn_seq_tb;
    logic [WIDTH-1:0] x_out1_tb;
    logic [WIDTH-1:0] x_out2_tb;
    logic [WIDTH-1:0] s_out_tb;

    // Instantiate the SwitchingBlock module
    SwitchingBlock #(
        .WIDTH(WIDTH)
    ) uut (
        .clk_i(clk_tb),
        .reset_i(reset_tb),
        .x_in_i(x_in_tb),
        .loop_filter_value_i(loop_filter_value_tb),
        .pn_seq_i(pn_seq_tb),
        .x_out1_o(x_out1_tb),
        .x_out2_o(x_out2_tb),
        .s_out_o(s_out_tb)
    );

    // Clock generation
    always begin
        #5 clk_tb = ~clk_tb;  // Clock period of 10ns
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk_tb = 0;
        reset_tb = 0;
        x_in_tb = 0;
        loop_filter_value_tb = 0;
        pn_seq_tb = 0;

        // Reset the DUT
        $display("Starting test: Resetting DUT");
        reset_tb = 1;
        #10 reset_tb = 0;  // Apply reset for 10ns
        
        // Monitor signals
        $monitor("Time: %t | clk: %b | reset: %b | x_in: %h | loop_filter_value: %h | pn_seq: %b | x_out1: %h | x_out2: %h | s_out: %h", 
                 $time, clk_tb, reset_tb, x_in_tb, loop_filter_value_tb, pn_seq_tb, x_out1_tb, x_out2_tb, s_out_tb);

        // Test case 1: Basic input
        $display("Test Case 1: Basic input (x_in = 0x01, loop_filter_value = 0x10, pn_seq = 1)");
        x_in_tb = 8'h01;
        loop_filter_value_tb = 8'h10;
        pn_seq_tb = 1;
        #20; // Wait for 2 clock cycles

        // Test case 2: Change PN sequence
        $display("Test Case 2: Change PN sequence (x_in = 0x02, loop_filter_value = 0x20, pn_seq = 0)");
        x_in_tb = 8'h02;
        loop_filter_value_tb = 8'h20;
        pn_seq_tb = 0;
        #20;

        // Test case 3: Large loop filter value (wrap around)
        $display("Test Case 3: Large loop filter value (x_in = 0x10, loop_filter_value = 0xFF, pn_seq = 1)");
        x_in_tb = 8'h10;
        loop_filter_value_tb = 8'hFF;  // Wrap around value
        pn_seq_tb = 1;
        #20;

        // Test case 4: Edge case for switching sequence
        $display("Test Case 4: Edge case for switching sequence (x_in = 0xFF, loop_filter_value = 0x80, pn_seq = 0)");
        x_in_tb = 8'hFF;  // Max input value
        loop_filter_value_tb = 8'h80;
        pn_seq_tb = 0;
        #20;

        // Test case 5: Reset in middle of operation
        $display("Test Case 5: Reset in middle of operation");
        x_in_tb = 8'h40;
        loop_filter_value_tb = 8'h30;
        pn_seq_tb = 1;
        #10;
        reset_tb = 1;  // Apply reset
        #10;
        reset_tb = 0;  // Release reset
        #10;

        // Test case 6: Check for maximum x_out values
        $display("Test Case 6: Check maximum x_out values");
        x_in_tb = 8'h80;
        loop_filter_value_tb = 8'h50;
        pn_seq_tb = 1;
        #20;

        // Test case 7: Check minimum x_out values
        $display("Test Case 7: Check minimum x_out values");
        x_in_tb = 8'h00;  // Min input value
        loop_filter_value_tb = 8'h00;
        pn_seq_tb = 0;
        #20;

        // Test case 8: Random sequence test
        $display("Test Case 8: Random sequence test");
        x_in_tb = 8'h55;  // Some random value
        loop_filter_value_tb = 8'hAA;
        pn_seq_tb = 1;
        #20;

        // Finish simulation
        $finish;
    end

endmodule
