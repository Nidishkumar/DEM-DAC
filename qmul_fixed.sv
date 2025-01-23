module qmul_fixed #(
    parameter I = 16,                                                      //I ---> Integer part,    for double precission I = 12
    parameter F = 16                                                      //F ---> Fractional part, for double precission F = 52
)
(
    input   logic   signed [(I+F-1):0]  a_i,                              //input operand for multiplier
    input   logic   signed [(I+F-1):0]  b_i,                              //input operand for multiplier
    output  logic   signed [(I+F)-1:0]  product_o                         //output of the multiplier
);
  
    logic signed [(I+F)-1:0]    scaled_product;                           //variable to hold the actual output which is clamped from clamp module
    logic signed [2*(I+F)-1:0]  product;                                  //variable to hold the multiplier output
    logic signed [(I+F-1):0]    max_val;                                  // Maximum representable value
    logic signed [(I+F-1):0]    min_val;
    logic signed [(I+F)-1:0]    result;

    assign max_val = {1'b0,{(I+F-1){1'b1}}};
    assign min_val = {1'b1,{(I+F-1){1'b0}}};

    always_comb begin   
        product = a_i * b_i;                                                //basic multiplication operation
        scaled_product = product[(I+(2*F))-1:F];                            //clamping the output to the required bits(lower bits)
        
        if (scaled_product > max_val) 
            product_o = max_val;
        else if (scaled_product < min_val) 
            product_o = min_val;
        else
            product_o = scaled_product;  
    end
    
 
endmodule
