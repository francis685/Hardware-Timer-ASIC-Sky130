`timescale 1ns / 1ps

module apb_counter_tb();

    // APB Signals (Driven by the testbench "CPU")
    reg         PCLK;
    reg         PRESETn;
    reg  [31:0] PADDR;
    reg         PSEL;
    reg         PENABLE;
    reg         PWRITE;
    reg  [31:0] PWDATA;
    
    // Outputs from the wrapper
    wire [31:0] PRDATA;
    wire        PREADY;

    // Instantiate the Wrapper
    apb_counter_wrapper uut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Generate a 100MHz System Clock
    always #5 PCLK = ~PCLK;

    initial begin
        // Initialize all signals to zero
        PCLK = 0;
        PRESETn = 0; // Hold Reset low (active)
        PADDR = 0;
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        PWDATA = 0;

        // Release reset after 20ns
        #20 PRESETn = 1;

        // Wait a few clock cycles to let the counter tick up a bit
        #50;

        // ----------------------------------------------------
        // APB TRANSACTION 1: Read the current count
        // ----------------------------------------------------
        // Setup Phase
        @(posedge PCLK);
        PADDR = 32'h0000_0000;
        PWRITE = 1'b0; // 0 means READ
        PSEL = 1'b1;
        PENABLE = 1'b0;
        
        // Access Phase
        @(posedge PCLK);
        PENABLE = 1'b1;
        
        // Wait for Ready (our wrapper is always ready)
        @(posedge PCLK);
        PSEL = 1'b0;
        PENABLE = 1'b0;

        // Wait a bit, let the counter tick up some more
        #80;

        // ----------------------------------------------------
        // APB TRANSACTION 2: Read the counter again
        // ----------------------------------------------------
        // Setup Phase
        @(posedge PCLK);
        PADDR = 32'h0000_0000;
        PWRITE = 1'b0; 
        PSEL = 1'b1;
        PENABLE = 1'b0;
        
        // Access Phase
        @(posedge PCLK);
        PENABLE = 1'b1;
        
        @(posedge PCLK);
        PSEL = 1'b0;
        PENABLE = 1'b0;

        // End simulation
        #50 $finish;
    end

endmodule