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
    // Internal signal arrays to store connections
    logic [INPUT_WIDTH-1:0] x_out1 [2];
    logic [INPUT_WIDTH-1:0] x_out2 [4];
    logic [INPUT_WIDTH-1:0] x_out3 [8];
    // Layer 1 (Single Instance)
    TopModule top_module_1 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_in_i(x_in_i),
        .x_out1_o(x_out1[0]),
        .x_out2_o(x_out1[1])		  
    );
    // Layer 2 (2 Instances)
    generate
        genvar i;
        for (i = 0; i < 2; i++) begin : gen_layer_2
            TopModule top_module_2 (
                .clk_i(clk_i),
                .reset_i(reset_i),
                .x_in_i(x_out1[i]),      
                .x_out1_o(x_out2[2*i]),  
                .x_out2_o(x_out2[2*i+1])					 
            );
        end
    endgenerate
    // Layer 3 (4 Instances)
    generate
        genvar j;
        for (j = 0; j < 4; j++) begin : gen_layer_3
            TopModule top_module_3 (
                .clk_i(clk_i),
                .reset_i(reset_i),
                .x_in_i(x_out2[j]),      
                .x_out1_o(x_out3[2*j]),  
                .x_out2_o(x_out3[2*j+1])
            );
        end
    endgenerate
    // Assigning the final outputs
    assign x_out3_1_o = x_out3[0];
    assign x_out3_2_o = x_out3[1];
    assign x_out3_3_o = x_out3[2];
    assign x_out3_4_o = x_out3[3];
    assign x_out3_5_o = x_out3[4];
    assign x_out3_6_o = x_out3[5];
    assign x_out3_7_o = x_out3[6];
    assign x_out3_8_o = x_out3[7];
endmodule