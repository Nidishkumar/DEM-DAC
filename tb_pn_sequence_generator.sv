module tb_pn_sequence_generator;
    // Testbench signals
    logic clk;
    logic reset;
    logic pn_seq;

    // Instantiate the pn_sequence_generator module
    pn_sequence_generator pn_gen_inst (
        .clk(clk),
        .reset(reset),
        .pn_seq(pn_seq)
    );

    // Clock generation (50 MHz clock)
    always begin
        #10 clk = ~clk;  // Toggle clock every 10ns, gives a 50MHz clock
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        
        // Apply reset
        $display("Applying reset...");
        reset = 1;
        #20;  // Hold reset for two clock cycles
        reset = 0;
        
        // Monitor the pn_seq output for 100 clock cycles
        $display("Starting simulation...");
        $monitor("At time %t, pn_seq = %b", $time, pn_seq);
        
        #200;  // Simulate for 200ns (20 clock cycles)
        
        $display("Simulation complete.");
        $finish;
    end
endmodule
