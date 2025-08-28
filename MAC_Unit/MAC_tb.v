`timescale 1ns / 1ps

module MAC_tb();
    reg clk_tb;
    reg reset_tb;
    reg output_signal_tb;
    reg [DATA_WIDTH-1:0] B_tb;
    reg [DATA_WIDTH-1:0] C_tb;
    wire [ACC_WIDTH-1:0] result_tb;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH = 16;

    MAC instant
    (
        .clk(clk_tb),
        .reset(reset_tb),
        .output_signal(output_signal_tb),
        .B(B_tb),
        .C(C_tb),
        .result(result_tb)
    );

    always begin
        #10;
        clk_tb = ~clk_tb;
    end
    
    initial
    begin
        clk_tb = 0;
        reset_tb = 0;
        output_signal_tb = 0;
        B_tb = 5;
        C_tb = 3;
        // Flip flop should contain 15

        #20;
        B_tb = 4;
        C_tb = 2;
        // flip flop should contain 23

        #20
        B_tb = 6;
        C_tb = 3;
        // flip flop should contain 41

        #20
        B_tb = 0;
        C_tb = 0;
        output_signal_tb = 1;
        // output should be 41

        #20
        reset_tb = 1;

    end
endmodule
