// Module name: Switching Block layers
// Description:Instantiates the topmodule os switching block to generate layers
// Date: 
// Version: 1.0
// Author: 


import lib_switchblock_pkg::*;

module SwitchingBlockLayers (
    input  logic                          clk_i,
    input  logic                          reset_i,
    input  logic [INPUT_WIDTH-1:0]        x_in_i,
    output logic [INPUT_WIDTH-1:0]        x_out3_1_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_2_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_3_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_4_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_5_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_6_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_7_o,
    output logic [INPUT_WIDTH-1:0]        x_out3_8_o
);

    // Internal signals to connect between instances
    logic [INPUT_WIDTH-1:0] x_out1_1, x_out1_2;
    logic [INPUT_WIDTH-1:0] x_out2_1, x_out2_2, x_out2_3, x_out2_4;

    // First instantiation (Layer 1)
    TopModule top_module_1 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out1_o(x_out1_1),  // Output 1 → Input to second layer
        .x_out2_o(x_out1_2),  // Output 2 → Input to third instance
        .s_out_o()            // Unused select output
    );

    // Second layer instantiations (Layer 2)
    TopModule top_module_2 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out1_1),  // Takes first output from first instance
        .x_out1_o(x_out2_1), // Output to third layer
        .x_out2_o(x_out2_2), // Output to third layer
        .s_out_o()
    );

    TopModule top_module_3 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out1_2),  // Takes second output from first instance
        .x_out1_o(x_out2_3), // Output to third layer
        .x_out2_o(x_out2_4), // Output to third layer
        .s_out_o()
    );

    // Third layer instantiations (Layer 3)
    TopModule top_module_4 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out2_1),  // Takes first output from second layer
        .x_out1_o(x_out3_1_o),
        .x_out2_o(x_out3_2_o),
        .s_out_o()
    );

    TopModule top_module_5 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out2_2),  // Takes second output from second layer
        .x_out1_o(x_out3_3_o),
        .x_out2_o(x_out3_4_o),
        .s_out_o()
    );

    TopModule top_module_6 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out2_3),  // Takes third output from second layer
        .x_out1_o(x_out3_5_o),
        .x_out2_o(x_out3_6_o),
        .s_out_o()
    );

    TopModule top_module_7 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_out2_4),  // Takes fourth output from second layer
        .x_out1_o(x_out3_7_o),
        .x_out2_o(x_out3_8_o),
        .s_out_o()
    );

endmodule


