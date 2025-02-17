// Module name: Switching Block layers
// Description:Instantiates the topmodule os switching block to generate layers
// Date: 
// Version: 1.0
// Author:
import lib_switchblock_pkg::*;

module SwitchingBlockLayers ( 
    input  logic                          clk_i,
    input  logic                          reset_i,
    input  logic signed [INPUT_WIDTH-1:0]        x_in_i,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_1_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_2_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_3_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_4_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_5_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_6_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_7_o,
    output logic signed [INPUT_WIDTH-1:0]        x_out3_8_o,

    // Status registers for each layer
    output logic [2:0]                    active_layer,   // Indicates active processing layer
    output logic                           layer1_status,  // 1 = Output is valid, 0 = Error detected
    output logic                           layer2_status,  
    output logic                           layer3_status,  
    output logic                           error_flag      // Global error flag if any layer fails
);

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
	 
	 // Combinational assignment for error_flag
    assign error_flag = !(layer1_status && layer2_status && layer3_status);

    // Status register logic
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            active_layer   <= 3'b000;
            layer1_status  <= 1'b0;
            layer2_status  <= 1'b0;
            layer3_status  <= 1'b0;
        end else begin
            // Determine active layer
            if (x_out1[0] != 0 || x_out1[1] != 0) active_layer <= 3'd1;
            if (x_out2[0] != 0 || x_out2[1] != 0 || x_out2[2] != 0 || x_out2[3] != 0) active_layer <= 3'd2;
            if (x_out3[0] != 0 || x_out3[1] != 0 || x_out3[2] != 0|| x_out3[3] != 0|| x_out3[4] != 0|| x_out3[5] != 0|| x_out3[6] != 0|| x_out3[7] != 0) active_layer <= 3'd3;

            // Check if outputs are valid at each layer
            layer1_status <= (x_out1[0] != 0) && (x_out1[1] != 0);
            layer2_status <= (x_out2[0] != 0) && (x_out2[1] != 0) && (x_out2[2] != 0) && (x_out2[3] != 0);
            layer3_status <= (x_out3[0] != 0) && (x_out3[1] != 0) && (x_out3[2] != 0) && (x_out3[3] != 0) &&
                             (x_out3[4] != 0) && (x_out3[5] != 0) && (x_out3[6] != 0) && (x_out3[7] != 0);
        end
    end
endmodule