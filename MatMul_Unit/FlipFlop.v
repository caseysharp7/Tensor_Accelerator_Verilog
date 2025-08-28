`timescale 1 ns / 1 ps

module FlipFlop(clk, reset, d, q);
    input clk;
    input reset;
    input [DATA_WIDTH-1:0] d;
    output reg [DATA_WIDTH-1:0] q;
    
    initial
    begin
        q = 0;
    end
    
    always @(posedge clk)
    begin
        if(reset == 1'b1)
            q <= 0;
        else
            q <= d;
    end
endmodule