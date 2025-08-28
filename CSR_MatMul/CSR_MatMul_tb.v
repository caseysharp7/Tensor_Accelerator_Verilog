`timescale 1ns / 1ps

module CSR_MatMul_tb();
    reg clk;
    reg reset;
    reg start;
    reg [(MAT1_ROWS+1)*PTR_SIZE - 1:0] Mat1_ptr_in;
    reg [(MAT1_LEN*OFFSET_SIZE) - 1:0] Mat1_offsets_in;
    reg [(MAT1_LEN*DATA_SIZE) - 1:0] Mat1_data_in;
    reg [MAT2_SIZE-1:0] Mat2_in;
    wire [MAT1_ROWS*MAT2_COLS*ACC_SIZE-1:0] result;

    reg [ACC_WIDTH-1:0] result_tb1, result_tb2, result_tb3, result_tb4, result_tb5, result_tb6, result_tb7, result_tb8, result_tb9;

    parameter MAT1_ROWS = 3;
    parameter MAT1_LEN = 9;
    parameter MAT2_ROWS = 3;
    parameter MAT2_COLS = 3;
    parameter MAT2_LEN = 9;
    parameter ACC_SIZE = 16;
    parameter PTR_SIZE = 4;
    parameter OFFSET_SIZE = 2;
    parameter DATA_SIZE = 8;

    parameter RESULT_ROW_SIZE1 = MAT1_ROWS*ACC_SIZE;
    parameter ROW_SIZE2 = MAT2_ROWS*DATA_SIZE;
    parameter MAT2_SIZE = MAT2_ROWS*MAT2_COLS*DATA_SIZE;


    
    CSR_MatMul instant 
    (
        .clk(clk),
        .reset(reset),
        .start(start),
        .Mat1_ptr_in(Mat1_ptr_in),
        .Mat1_offsets_in(Mat1_offsets_in),
        .Mat1_data_in(Mat1_data_in),
        .Mat2_in(Mat2_in),
        .result(result_tb)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        start = 0;

        Mat1_ptr_in = {4'd0, 4'd1, 4'd3, 4'd4};
        Mat1_offsets_in = {2'd2, 2'd1, 2'd2, 2'd0, 2'd0, 2'd0, 2'd0, 2'd0, 2'd0};
        Mat1_data_in = {8'd2, 8'd5, 8'd2, 8'd3, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
        //   [0 0 2]
        //   [0 5 2]
        //   [3 0 0]

        Mat2_in = {8'd6, 8'd3, 8'd0, 8'd5, 8'd7, 8'd2, 8'd1, 8'd3, 8'd4};
        //   [6 3 0]
        //   [5 7 2]
        //   [1 3 4]

        // Result should be: 
        //   [2  6  8]
        //   [27 41 18]
        //   [18 9  0]

        #10;
        reset = 0;
        start = 1;




    end


endmodule