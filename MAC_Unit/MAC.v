`timescale 1ns / 1ps

module MAC(
        input clk,
        input reset,
        input output_signal,
        input [DATA_WIDTH-1:0] B,
        input [DATA_WIDTH-1:0] C,
        output [ACC_WIDTH-1:0] result
    );
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH = 16;

    wire [ACC_WIDTH-1:0] prod, Ain, Aout;
    
    multiplier mult_unit(
        .B(B),
        .C(C),
        .Product(prod)
    );

    adder add_unit(
        .Product(prod),
        .Ain(Ain),
        .Aout(Aout)
    );

    FlipFlop flipflop(
        .clk(clk),
        .reset(reset),
        .d(Aout),
        .q(Ain)
    );

    // if output_signal is set then output current value in flipflop, so Ain

endmodule