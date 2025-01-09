module SecondOrderIIRNotchFilter #(
    parameter WIDTH = 16  // Bit width of the signals and coefficients
)(
    input logic clk,                        // Clock signal
    input logic reset,                      // Reset signal
    input logic [WIDTH-1:0] x_in,           // Current input signal (signed)
    output logic [2*WIDTH-1:0] y_out,         // Current output signal (signed)
    output logic [WIDTH-1:0] ntf_out,       // Noise Transfer Function output (signed)

    output logic [WIDTH-1:0] x_prev1,       // Previous input x[n-1]
    output logic [WIDTH-1:0] x_prev2,       // Previous input x[n-2]
    output logic [WIDTH-1:0] y_prev1,       // Previous output y[n-1]
    output logic [WIDTH-1:0] y_prev2        // Previous output y[n-2]
);

    // Coefficients for the notch filter (scaled for 16-bit signed values)
    logic signed [WIDTH-1:0] b0 = 16'sd16384;    // Numerator coefficient b0 
    logic signed [WIDTH-1:0] b1 = -16'sd1010;   // Numerator coefficient b1 
    logic signed [WIDTH-1:0] b2 = 16'sd16384;    // Numerator coefficient b2 
    logic signed [WIDTH-1:0] a1 = -16'sd1010;   // Denominator coefficient a1
    logic signed [WIDTH-1:0] a2 = 16'sd163;     // Denominator coefficient a2 

    // Temporary intermediate variables for x_in and y_out
    logic signed [WIDTH-1:0] temp_xin;
    logic signed [2*WIDTH-1:0] temp_yout;

    // Temporary intermediate result for the output calculation
    logic signed [2*WIDTH-1:0] intermediate;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all states and outputs to zero
            x_prev1 <= 0;
            x_prev2 <= 0;
            y_prev1 <= 0;
            y_prev2 <= 0;
            y_out <= 0;
            ntf_out <= 0;
            temp_xin <= 0;
            temp_yout <= 0;
        end else begin
            // Step 1: Use temp variables for x_in and y_out
            temp_xin <= x_in;

            // Calculate the output using the difference equation
           
				intermediate = 
				    (a1 * y_prev1)+
					 (a2 * y_prev2)+
					 
					 (b0 * x_in) +
                (b1 * x_prev1)+
                (b2 * x_prev2)
					 ; 
                
                  

             // Limit the output to the signal width
            temp_yout = intermediate;//[2*WIDTH-1:0];

            // Step 2: Update past input and output values after calculation
            x_prev2 <= x_prev1;
            x_prev1 <= temp_xin;
           y_prev2 <= y_prev1;
            y_prev1 <= temp_yout;

            // Step 3: Assign the calculated output
            y_out <= temp_yout;

            // Step 4: Calculate Noise Transfer Function (NTF) output
            if (temp_yout != 0) begin
                ntf_out <= ((1 << WIDTH) - temp_yout) / temp_yout; // NTF = (1 - H(z)) / H(z)
            end else begin
                ntf_out <= 0; // Default to zero if division by zero
            end
        end
    end
endmodule

 