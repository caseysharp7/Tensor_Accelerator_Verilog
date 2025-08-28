`timescale 1ns / 1ps

module MatMul_Unit(
        input clk,
        input reset,
        input start,
        input [MAT1_SIZE-1:0] Mat1_in,
        input [MAT2_SIZE-1:0] Mat2_in,
        output [ROW_LEN1*COL_LEN2*ACC_WIDTH-1:0] result
    );

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

    wire [DATA_WIDTH-1:0] Mat1[0:ROW_LEN1-1][0:COL_LEN1-1];
    wire [DATA_WIDTH-1:0] Mat2[0:ROW_LEN2-1][0:COL_LEN2-1];
    /*
    genvar i, j;
    generate
        for(i = 0; r < ROW_LEN1; i = i+1) begin : loop1
            for(j = 0; j < COL_LEN1; j = j+1) begin : loop2
                assign Mat1[i][j] = Mat1_in[(i*ROW_SIZE + j*DATA_WIDTH) +: DATA_WIDTH];
            end
        end
    endgenerate 
    */

    genvar i, j;
    generate
        for(i = ROW_LEN1 - 1; i >= 0; i = i-1) begin : loop1
            for(j = COL_LEN1; j >= 1; j = j-1) begin : loop2
                localparam r = (ROW_LEN1-1) - i;
                localparam c = (COL_LEN1) - j;
                assign Mat1[r][c] = Mat1_in[(i*ROW_SIZE1 + j*DATA_WIDTH) - 1 -: DATA_WIDTH];
            end
        end
    endgenerate

    genvar k, l;
    generate
        for(k = ROW_LEN2 - 1; k >= 0; k = k-1) begin : loop3
            for(l = COL_LEN2 ; l >= 1; l = l-1) begin : loop4
                localparam r = (ROW_LEN2-1) - k;
                localparam c = (COL_LEN2) - l;
                assign Mat2[r][c] = Mat2_in[(k*ROW_SIZE2 + l*DATA_WIDTH) - 1 -: DATA_WIDTH];
            end
        end
    endgenerate

    genvar m, n;
    generate
        for(m = 0; m < ROW_LEN1; m = m+1) begin : loop5
            for(n = 0; n < COL_LEN2; n = n+1) begin : loop6
                MAC3 mac_unit (
                    .clk(clk),
                    .reset(reset),
                    .start(start),
                    .Row({Mat1[m][0], Mat1[m][1], Mat1[m][2]}),
                    .Col({Mat2[0][n], Mat2[1][n], Mat2[2][n]}),
                    .result(result[((ROW_LEN1-1)-m)*(ROW_SIZE1*2) + ((COL_LEN2)-n)*ACC_WIDTH - 1 -: 16])
                );
            end
        end
    endgenerate
    
endmodule
