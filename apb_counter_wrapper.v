module apb_counter_wrapper (
    // AMBA APB Interface Signals
    input  wire        PCLK,     // APB System Clock
    input  wire        PRESETn,  // APB System Reset (Active Low)
    input  wire [31:0] PADDR,    // APB Address Bus
    input  wire        PSEL,     // APB Peripheral Select
    input  wire        PENABLE,  // APB Enable (Access Phase)
    input  wire        PWRITE,   // APB Write Control (0 = Read, 1 = Write)
    input  wire [31:0] PWDATA,   // APB Write Data Bus
    output reg  [31:0] PRDATA,   // APB Read Data Bus
    output wire        PREADY    // APB Ready Signal
);

    // Internal wires connecting to your original counter
    wire [3:0] count_out;
    wire internal_rst;

    // APB reset is active-low (0 means reset). Your counter uses active-high (1 means reset).
    assign internal_rst = ~PRESETn;

    // Instantiate your original verified counter module
    counter_4bit u_counter (
        .clk(PCLK),
        .rst(internal_rst),
        .count(count_out)
    );

    // APB Read Logic
    // If the CPU reads from memory address 0x00000000, send the counter value.
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA <= 32'h0000_0000;
        end else if (PSEL && PENABLE && !PWRITE) begin
            if (PADDR == 32'h0000_0000) begin
                // Zero-extend the 4-bit count to fit the 32-bit APB bus
                PRDATA <= {28'h0, count_out}; 
            end else begin
                PRDATA <= 32'h0000_0000;
            end
        end
    end

    // Since our simple counter responds instantly, PREADY is always High (1)
    assign PREADY = 1'b1;

endmodule