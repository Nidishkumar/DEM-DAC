// Module name: Switching Block layers
// Description:Instantiates the topmodule os switching block to generate layers
// Date: 
// Version: 1.0
// Author: 
import lib_switchblock_pkg::*;
module SwitchingBlockLayers_2 (
    input  logic                          clk_i,
    input  logic                          reset_i,
    input  logic [INPUT_WIDTH-1:0]        x_in_i,
    output logic [INPUT_WIDTH-1:0]        x_out2_1_o, x_out2_2_o, 
                                          x_out2_3_o, x_out2_4_o
);
    // Internal signals to connect between instances
    logic [INPUT_WIDTH-1:0] x_out1_1_o, x_out1_2_o;
    // First instance of TopModule - Takes x_in_i as input
    TopModule top_module_1 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out1_o(x_out1_1_o),                                              // Output 1 -> Input for second instance
        .x_out2_o(x_out1_2_o),                                              // Output 2 -> Input for third instance
        .s_out_o()              
    );
    // Second instance of TopModule - Takes x_out1_1_o as input
    TopModule top_module_2 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out1_1_o),  
        .x_out1_o(x_out2_1_o), 
        .x_out2_o(x_out2_2_o),
        .s_out_o()
    );
    // Third instance of TopModule - Takes x_out1_2_o as input
    TopModule top_module_3 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out1_2_o),  
        .x_out1_o(x_out2_3_o), 
        .x_out2_o(x_out2_4_o),
        .s_out_o()
    );
endmodule
