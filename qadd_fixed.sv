// Module name: qadd_fixed
// Description: Generates the n bit output when two n bit values are added.
// Date: 
// Version: 1.0
// Author: 
//`include "lib_switchblock_pkg.sv"
import lib_switchblock_pkg::*;
module qadd_fixed (
    input  logic   signed [(I+F-1):0] a_i,                                                // Input a
    input  logic   signed [(I+F-1):0] b_i,                                                // Input b
    output logic   signed [(I+F-1):0] result_o                                            // Output result with clamping
);
   // Internal signals
   // logic signed [(I+F-1):0] result;
    logic signed [(I+F):0] sum;                                                           // Extended bit-width for addition
    logic signed [(I+F-1):0] max_val;                                                     // Maximum representable value
    logic signed [(I+F-1):0] min_val;                                                     // Minimum representable value
    // Define clamping bounds                                           
    assign max_val = {1'b0,{(I+F-1){1'b1}}};
    assign min_val = {1'b1,{(I+F-1){1'b0}}};                                              // Negative min value
    // Compute sum with extended bit-width for detection of overflow
    assign sum = a_i + b_i;    
    // Clamping logic for overflow and underflow
    always_comb begin
        if (a_i >= 0 && b_i >= 0 && sum[I+F-1]) 
            result_o   = max_val;                                                         // Clamp to maximum value
        else if (a_i < 0 && b_i < 0 && !(sum[I+F-1]))                                                     
            result_o = min_val;                                                           // Clamp to minimum value
        else
            result_o = sum[(I+F-1):0];                                                    // Use only (I+F) bits of result
    end
endmodule