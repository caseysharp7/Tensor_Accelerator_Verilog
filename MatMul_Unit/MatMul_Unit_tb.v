`timescale 1ns / 1ps

module MatMul_Unit_tb();
    reg clk_tb;
    reg reset_tb;
    reg start_tb;
    reg [MAT1_SIZE-1:0] Mat1_in_tb;
    reg [MAT2_SIZE-1:0] Mat2_in_tb;
    wire [ROW_LEN1*COL_LEN2*ACC_WIDTH-1:0] result_tb;

    reg [ACC_WIDTH-1:0] result_tb1, result_tb2, result_tb3, result_tb4, result_tb5, result_tb6, result_tb7, result_tb8, result_tb9;

    

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH = 16;
    parameter ROW_LEN1 = 3;
    parameter COL_LEN1 = 3;
    parameter ROW_LEN2 = 3;
    parameter COL_LEN2 = 3;
    parameter MAT1_SIZE = ROW_LEN1*COL_LEN1*DATA_WIDTH;
    parameter MAT2_SIZE = ROW_LEN2*COL_LEN2*DATA_WIDTH;
    parameter ROW_SIZE1 = DATA_WIDTH*ROW_LEN1; // 24
    parameter COL_SIZE1 = DATA_WIDTH*COL_LEN1;
    parameter ROW_SIZE2 = DATA_WIDTH*ROW_LEN2;
    parameter COL_SIZE2 = DATA_WIDTH*COL_LEN2;

    MatMul_Unit instant
    (
        .clk(clk_tb),
        .reset(reset_tb),
        .start(start_tb),
        .Mat1_in(Mat1_in_tb),
        .Mat2_in(Mat2_in_tb),
        .result(result_tb)
    );
    
    always begin
        #10;
        clk_tb = ~clk_tb;
    end

    initial begin
        clk_tb = 0;
        reset_tb = 0;
        start_tb = 0;
        Mat1_in_tb = 72'b00001010_00010001_00000010_00000101_00000001_00000000_00011100_00010000_00000101;  // hex: a11020501001c1005
                        // (10 17 2)
                        // (5  1  0)
                        // (28 16 5)

        Mat2_in_tb = 72'b00000000_00010100_00001000_00010101_00000010_00100000_00000100_00000000_00000001;  // hex: 1408150220040001
                        // (0  20 8) 
                        // (21 2  32)
                        // (4  0  1) 

        #5;
        start_tb = 1;
        /* result should be (365 234 626)
                            (21  102 72) 
                            (356 592 741)    
        0000000101101101_0000000100010010_0000001010000010
        0000000000010101_0000000001100110_0000000001001000
        0000000101100100_0000001001010000_0000001011100101
        hex: 16d011202820015006600480164025002e5
        */
        
        #30
        result_tb1 = result_tb[143 -: 16];
        result_tb2 = result_tb[127 -: 16];
        result_tb3 = result_tb[111 -: 16];
        result_tb4 = result_tb[95 -: 16];
        result_tb5 = result_tb[79 -: 16];
        result_tb6 = result_tb[63 -: 16];
        result_tb7 = result_tb[47 -: 16];
        result_tb8 = result_tb[31 -: 16];
        result_tb9 = result_tb[15 -: 16];

        #50;
        Mat2_in_tb = 72'b00000000_00001010_00001000_00010101_00000010_00100000_00000100_00000000_00000001;
                        // (0  10 8) 
                        // (21 2  32)
                        // (4  0  1) 
        
        
        /* result should be (365 134 626)
                            (21  52  72) 
                            (356 312 741)    
        0000000101101101_0000000010011010_0000001010000010
        0000000000010101_0000000000110100_0000000001001000
        0000000101100100_0000000100111000_0000001011100101
        */

        #30;
        result_tb1 = result_tb[143 -: 16];
        result_tb2 = result_tb[127 -: 16];
        result_tb3 = result_tb[111 -: 16];
        result_tb4 = result_tb[95 -: 16];
        result_tb5 = result_tb[79 -: 16];
        result_tb6 = result_tb[63 -: 16];
        result_tb7 = result_tb[47 -: 16];
        result_tb8 = result_tb[31 -: 16];
        result_tb9 = result_tb[15 -: 16];

        #20;
        reset_tb = 1;

        #20;
        start_tb = 0;


    end





endmodule