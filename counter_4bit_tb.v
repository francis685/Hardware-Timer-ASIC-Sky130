`timescale 1ns / 1ps

module counter_4bit_tb;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // Hold reset for 20ns
        #20;
        rst = 0; 

        // Wait for enough clock cycles to see it count 0000 to 1111 and wrap around
        #200;

        // Assert reset again to verify it zeroes out correctly
        rst = 1;
        #20;
        rst = 0;
        #40;

        // End simulation
        $finish;
    end

endmodule