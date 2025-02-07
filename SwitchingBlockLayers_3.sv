import lib_switchblock_pkg::*;

module SwitchingBlockLayers_3 (
    input  logic                          clk_i,
    input  logic                          reset_i,
    input  logic [INPUT_WIDTH-1:0]        x_in2_1_i, x_in2_2_i, 
                                          x_in2_3_i, x_in2_4_i,
    output logic [INPUT_WIDTH-1:0]        x_out3_1_o, x_out3_2_o, 
                                          x_out3_3_o, x_out3_4_o,
                                          x_out3_5_o, x_out3_6_o, 
                                          x_out3_7_o, x_out3_8_o
);

    // Third-layer instantiations
    TopModule top_module_4 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in2_1_i),  
        .x_out1_o(x_out3_1_o), // Final third-layer output
        .x_out2_o(x_out3_2_o),
        .s_out_o()
    );

    TopModule top_module_5 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in2_2_i),  
        .x_out1_o(x_out3_3_o),
        .x_out2_o(x_out3_4_o),
        .s_out_o()
    );

    TopModule top_module_6 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in2_3_i),  
        .x_out1_o(x_out3_5_o),
        .x_out2_o(x_out3_6_o),
        .s_out_o()
    );

    TopModule top_module_7 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in2_4_i),  
        .x_out1_o(x_out3_7_o),
        .x_out2_o(x_out3_8_o),
        .s_out_o()
    );

endmodule
