// Testbench for SwitchingBlockLayers
// Description: Testbench to verify functionality of SwitchingBlockLayers
// Version: 1.1
// Author: 
import lib_switchblock_pkg::*;
module tb_SwitchingBlockLayers_2;
    // Inputs to the DUT
    logic clk_i;                                                                                   // Clock signal
    logic reset_i;                                                                                 // Reset signal
    logic signed [INPUT_WIDTH-1:0] x_in_i;                                                         // Input signal
    // Outputs from the DUT
    logic signed [INPUT_WIDTH-1:0] x_out3_1_o, x_out3_2_o, x_out3_3_o, x_out3_4_o;
    logic signed [INPUT_WIDTH-1:0] x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o;
    // Status signals
    logic [2:0] active_layer;
    logic layer1_status, layer2_status, layer3_status;
    logic error_flag, overflow_flag, zero_flag;
    // Instantiate the DUT (Device Under Test)
    SwitchingBlockLayers_2 uut (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out3_1_o(x_out3_1_o),
        .x_out3_2_o(x_out3_2_o),
        .x_out3_3_o(x_out3_3_o),
        .x_out3_4_o(x_out3_4_o),
        .x_out3_5_o(x_out3_5_o),
        .x_out3_6_o(x_out3_6_o),
        .x_out3_7_o(x_out3_7_o),
        .x_out3_8_o(x_out3_8_o),
        .active_layer(active_layer),
        .layer1_status(layer1_status),
        .layer2_status(layer2_status),
        .layer3_status(layer3_status),
        .error_flag(error_flag),
        .overflow_flag(overflow_flag),
        .zero_flag(zero_flag)
    );
    // Clock generation (100 MHz clock)
    always #5 clk_i = ~clk_i;                                                                      // Toggle every 5 ns for a 100 MHz clock  
    // Task for applying test cases
    task apply_test(input logic [INPUT_WIDTH-1:0] test_value, input string test_name);
        begin
            x_in_i = test_value;
            #40;                                                                                   // Wait for outputs to settle
            $display("-------------------------------------------------------------------------------------------------------------------------------------------------------------------");
            $display("| %-9s | %-7d | %-7d | %-7d | %-7d | %-7d | %-7d | %-7d | %-7d | %-7d | %-2d   | %-2b  |  %-2b  |  %-2b  | %-2b  | %-2b  | %-2b  |", 
         test_name, x_in_i, x_out3_1_o, x_out3_2_o, x_out3_3_o, 
         x_out3_4_o, x_out3_5_o, x_out3_6_o, x_out3_7_o, x_out3_8_o,
         active_layer, layer1_status, layer2_status, layer3_status, error_flag, overflow_flag, zero_flag);
            $display("-------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        end
    endtask   
    // Test procedure
    initial begin
        // Initialize signals
        clk_i = 0;
        reset_i = 1;
        x_in_i = 16'sd0;       
        // Apply reset
        #10 reset_i = 1;  // Hold reset for 2 clock cycles
        #10 reset_i = 0;      
        // Display table header
        $display("===================================================================================================================================================================");
        $display("| TestCase  | Input   | Out1    | Out2    | Out3    | Out4    | Out5    | Out6    | Out7    | Out8    | Layer | L1  | L2  | L3  | Err | Ovf | Zro |");
        $display("===================================================================================================================================================================");
        // Test cases with varied scenarios
        apply_test(16'sd32767, "TC1");                                                             // Maximum positive value
        apply_test(-16'sd32768, "TC2");                                                            // Minimum negative value
        apply_test(16'sd16384, "TC3");                                                             // Mid positive range
        apply_test(-16'sd16384, "TC4");                                                            // Mid negative range
        apply_test(16'sd8192, "TC5");                                                              // Quarter positive range
        apply_test(-16'sd8192, "TC6");                                                             // Quarter negative range
        apply_test(16'sd1, "TC7");                                                                 // Smallest positive value
        apply_test(-16'sd1, "TC8");                                                                // Smallest negative value
        apply_test(16'sd0, "TC9");                                                                 // Zero case (should set zero_flag)
        apply_test(16'sd25000, "TC10");                                                            // High mid positive value
        apply_test(-16'sd25000, "TC11");                                                           // High mid negative value
        apply_test(16'sd5000, "TC12");                                                             // Lower mid positive
        apply_test(-16'sd5000, "TC13");                                                            // Lower mid negative
        apply_test(16'sd10000, "TC14");                                                            // Positive boundary
        apply_test(-16'sd10000, "TC15");                                                           // Negative boundary
        apply_test(16'sd12345, "TC16");                                                            // Random positive
        apply_test(-16'sd12345, "TC17");                                                           // Random negative
        apply_test(16'sd5432, "TC18");                                                             // Random low positive
        apply_test(-16'sd5432, "TC19");                                                            // Random low negative
        apply_test(16'sd32766, "TC20");                                                            // Near max positive

        // Edge cases with overflow
        apply_test(16'hFFFF, "TC21");                                                              // Invalid input (all bits high, should set overflow_flag)
        apply_test(16'h8000, "TC22");                                                              // Invalid input (MSB high, should set overflow_flag)
        apply_test(16'h7FFF, "TC23");                                                              // Valid edge case (max positive integer)
        apply_test(16'h0001, "TC24");                                                              // Small positive value
        apply_test(16'h00x1, "TC25");                                                              // Small positive value
		  apply_test(16'h0zzz, "TC26");                                                            // Small positive value		  
        // Reset test
        reset_i = 1;
        #10 reset_i = 0;
        apply_test(16'sd25000, "TC27");       
        // End of test
        $display("===================================================================================================================================================================");
        $finish;
    end
endmodule
