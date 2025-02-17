// Module name: Switching Block Layers
// Description: Instantiates the top module of the switching block to generate layers
// Date: 
// Version: 1.1
// Author:
import lib_switchblock_pkg::*;
module SwitchingBlockLayers_2 ( 
    input  logic                          clk_i,
    input  logic                          reset_i,
    input  logic signed [INPUT_WIDTH-1:0] x_in_i,   
    output logic signed [INPUT_WIDTH-1:0] x_out3_1_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_2_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_3_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_4_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_5_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_6_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_7_o,
    output logic signed [INPUT_WIDTH-1:0] x_out3_8_o,
    // Status registers for each layer
    output logic [2:0]                    active_layer,                                                    // Indicates active processing layer
    output logic                           layer1_status,                                                  // 1 = Output is valid, 0 = Invalid
    output logic                           layer2_status,  
    output logic                           layer3_status,  
    output logic                           error_flag,                                                     // Global error flag if any layer fails
    output logic                           overflow_flag,                                                  // Set if input exceeds max threshold
    output logic                           zero_flag                                                       // Set if all outputs are exactly zero
);
   // Define threshold for overflow detection
    localparam signed MAX_INPUT_VALUE = (1 << (INPUT_WIDTH - 1)) - 1;
    // Internal signal arrays
    logic signed  [INPUT_WIDTH-1:0] x_out1 [2];
    logic signed  [INPUT_WIDTH-1:0] x_out2 [4];
    logic signed  [INPUT_WIDTH-1:0] x_out3 [8];
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
    // Assign final outputs
    assign x_out3_1_o = x_out3[0];
    assign x_out3_2_o = x_out3[1];
    assign x_out3_3_o = x_out3[2];
    assign x_out3_4_o = x_out3[3];
    assign x_out3_5_o = x_out3[4];
    assign x_out3_6_o = x_out3[5];
    assign x_out3_7_o = x_out3[6];
    assign x_out3_8_o = x_out3[7];
    // Status register logic
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            active_layer   <= 3'b000;
            layer1_status  <= 1'b0;
            layer2_status  <= 1'b0;
            layer3_status  <= 1'b0;
            overflow_flag  <= 1'b0;
            zero_flag      <= 1'b0;
            error_flag     <= 1'b0;
        end else begin
            // Error detection
            if (^x_in_i === 1'bx || ^x_in_i === 1'bz) begin
                error_flag    <= 1'b1;
                zero_flag     <= 1'b0;
                overflow_flag <= 1'b0;
            end else begin
                error_flag    <= 1'b0;               
                // Zero detection
                zero_flag     <= (x_in_i == 0);                
                // Overflow detection
                overflow_flag <= (x_in_i > MAX_INPUT_VALUE);
            end
            // Layer status checks
            layer1_status <= !(^x_out1[0] === 1'bx || ^x_out1[1] === 1'bx || 
                               ^x_out1[0] === 1'bz || ^x_out1[1] === 1'bz);
            
            layer2_status <= !(^x_out2[0] === 1'bx || ^x_out2[1] === 1'bx || ^x_out2[2] === 1'bx || ^x_out2[3] === 1'bx ||
                               ^x_out2[0] === 1'bz || ^x_out2[1] === 1'bz || ^x_out2[2] === 1'bz || ^x_out2[3] === 1'bz);
            
            layer3_status <= !(^x_out3[0] === 1'bx || ^x_out3[1] === 1'bx || ^x_out3[2] === 1'bx || ^x_out3[3] === 1'bx ||
                               ^x_out3[4] === 1'bx || ^x_out3[5] === 1'bx || ^x_out3[6] === 1'bx || ^x_out3[7] === 1'bx ||
                               ^x_out3[0] === 1'bz || ^x_out3[1] === 1'bz || ^x_out3[2] === 1'bz || ^x_out3[3] === 1'bz ||
                               ^x_out3[4] === 1'bz || ^x_out3[5] === 1'bz || ^x_out3[6] === 1'bz || ^x_out3[7] === 1'bz);
            
            // Active layer tracking
            if (layer1_status) active_layer <= 3'd1;
            if (layer2_status) active_layer <= 3'd2;
            if (layer3_status) active_layer <= 3'd3;
        end
    end
endmodule
