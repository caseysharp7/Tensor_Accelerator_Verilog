`timescale 1ns / 1ps
// Mac unit where the input will be a row from one matrix and a column of another

module MAC3(
        input clk,
        input reset,
        input start,
        input [ROW_SIZE-1:0] Row,
        input [COL_SIZE-1:0] Col,
        output [ACC_WIDTH-1:0] result
    );
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH = 16;
    parameter ROW_LEN = 3;
    parameter COL_LEN = 3;
    parameter ROW_SIZE = DATA_WIDTH*ROW_LEN;
    parameter COL_SIZE = DATA_WIDTH*COL_LEN;

    wire [DATA_WIDTH-1:0] Row1, Row2, Row3, Col1, Col2, Col3;
    reg [ACC_WIDTH-1:0] prod1, prod2, prod3;

    reg [ACC_WIDTH-1:0] acc;
    reg [1:0] step;

    FlipFlop ff_Row1(
        .clk(clk),
        .reset(reset),
        .d(Row[23:16]),
        .q(Row1)
    );
    FlipFlop ff_Row2(
        .clk(clk),
        .reset(reset),
        .d(Row[15:8]),
        .q(Row2)
    );
    FlipFlop ff_Row3(
        .clk(clk),
        .reset(reset),
        .d(Row[7:0]),
        .q(Row3)
    );
    FlipFlop ff_Col1(
        .clk(clk),
        .reset(reset),
        .d(Col[23:16]),
        .q(Col1)
    );
    FlipFlop ff_Col2(
        .clk(clk),
        .reset(reset),
        .d(Col[15:8]),
        .q(Col2)
    );
    FlipFlop ff_Col3(
        .clk(clk),
        .reset(reset),
        .d(Col[7:0]),
        .q(Col3)
    );
    
    // Option 1: three multiply units plus two adders for everything in parallel
    always@(posedge clk) 
    begin
        if(reset) begin
            prod1 <= 0;
            prod2 <= 0;
            prod3 <= 0;
        end
        else if(start) begin
            prod1 <= Row1*Col1;
            prod2 <= Row2*Col2;
            prod3 <= Row3*Col3;
        end
    end

    assign result = prod1 + prod2 + prod3;
    // Option 2: scheduled (will see if additional scheduling is needed down the line)
    // done step?
    /*
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            acc <= 0;
            step <= 0;
        end
        else begin
            case (step)
                0: acc <= Row1*Col1;
                1: acc <= acc + Row2*Col2;
                2: begin
                    acc <= acc + Row3*Col3;
                    result <= acc + Row3*Col3;
                end
            endcase
            step <= step + 1;
        end
    end 
    */

endmodule