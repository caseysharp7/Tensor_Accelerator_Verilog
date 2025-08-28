`timescale 1ns / 1ps

// base set to 3x3 matrix

module CSR_MatMul(
        input clk,
        input reset,
        input start,
        input [(MAT1_ROWS+1)*PTR_SIZE - 1:0] Mat1_ptr_in,
        input [(MAT1_LEN*OFFSET_SIZE) - 1:0] Mat1_offsets_in,
        input [(MAT1_LEN*DATA_SIZE) - 1:0] Mat1_data_in,

        input [MAT2_SIZE-1:0] Mat2_in,

        output [MAT1_ROWS*MAT2_COLS*ACC_SIZE-1:0] result
    );

    parameter MAT1_ROWS = 3;
    parameter MAT1_LEN = 9;
    parameter MAT2_ROWS = 3;
    parameter MAT2_COLS = 3;
    parameter MAT2_LEN = 9;
    parameter ACC_SIZE = 16;

    parameter RESULT_ROW_SIZE1 = MAT1_ROWS*ACC_SIZE;
    parameter ROW_SIZE2 = MAT2_ROWS*DATA_SIZE;
    parameter MAT2_SIZE = MAT2_ROWS*MAT2_COLS*DATA_SIZE;

    parameter PTR_SIZE = 4;
    parameter OFFSET_SIZE = 2;
    parameter DATA_SIZE = 8;

    parameter IDLE = 3'b000;
    parameter LOAD_ROW = 3'b001;
    parameter ROW_VALUES = 3'b010;
    parameter COL_VALUES = 3'b011;
    parameter DONE = 3'b100;

    wire [PTR_SIZE-1:0] Mat1_ptr[MAT1_ROWS:0];
    wire [OFFSET_SIZE-1:0] Mat1_offsets[MAT1_LEN-1:0];
    wire [DATA_SIZE-1:0] Mat1_data[MAT1_LEN-1:0];
    // Counter will only go to how many data values there are but I think the additional values are still present on the bus because the bus has to be that long

    wire [DATA_SIZE-1:0] Mat2[0:MAT2_ROWS-1][0:MAT2_COLS-1];
    reg [ACC_SIZE-1:0] result_temp[0:MAT1_ROWS-1][0:MAT2_COLS-1];

    reg [1:0] row_count, col_count, num_values, value_idx, value_count, offset_value;
    reg [2:0] state, next;
    reg [DATA_SIZE-1:0] value;
    reg done;

    genvar i;
    generate
        for(i = MAT1_ROWS; i >= 0; i = i-1) begin : ptr_loop1
            localparam r = (MAT1_ROWS) - i;
            assign Mat1_ptr[r] = Mat1_ptr_in[(i+1)*PTR_SIZE - 1 -: PTR_SIZE];
        end
    endgenerate
    generate
        for(i = MAT1_LEN; i >= 1; i = i-1) begin : offsets_loop1
            localparam r = (MAT1_LEN) - i;
            assign Mat1_offsets[r] = Mat1_offsets_in[(i)*OFFSET_SIZE - 1 -: OFFSET_SIZE];
        end
    endgenerate
    generate
        for(i = MAT1_LEN; i >= 1; i = i-1) begin : data_loop1
            localparam r = (MAT1_LEN) - i;
            assign Mat1_data[r] = Mat1_data_in[(i)*DATA_SIZE - 1 -: DATA_SIZE];
        end
    endgenerate

    genvar k, l;
    generate
        for(k = MAT2_ROWS - 1; k >= 0; k = k-1) begin : loop3
            for(l = MAT2_COLS ; l >= 1; l = l-1) begin : loop4
                localparam r = (MAT2_ROWS-1) - k;
                localparam c = (MAT2_COLS) - l;
                assign Mat2[r][c] = Mat2_in[(k*ROW_SIZE2 + l*DATA_SIZE) - 1 -: DATA_SIZE];
            end
        end
    endgenerate


    always @(posedge start) begin
        done = 1'b0;
    end

    always @(negedge start) begin
        done = 1'b1;
    end

    // Sequential block for FSM
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            done <= 1'b1;
        end

        else begin
            if(row_count == MAT1_ROWS-1) begin
                state <= DONE;
            end
            else begin
                state <= next;
            end
        end
    end

    // Combinational block for FSM

    always @(*) begin

        case (state) 
            IDLE: begin
                if(!done) begin
                    row_count = 0;
                    next = LOAD_ROW;
                end
            end

            LOAD_ROW: begin
                num_values = Mat1_ptr[row_count+1] - Mat1_ptr[row_count];
                value_idx = Mat1_ptr[row_count];
                value_count = 0;
                if(num_values) begin
                    next = ROW_VALUES;
                end
                else begin
                    row_count = row_count + 1;
                end
                    // I think just add an additional state so it can go to that state if there is a value in that row and stay there if there are more values and then go back to LOAD_ROW if there are no more
            end

            ROW_VALUES: begin
                if((num_values - value_count)) begin
                    offset_value = Mat1_offsets[value_idx];
                    value = Mat1_data[value_idx];

                    if(col_count) begin
                        value_idx = value_idx + 1;
                        value_count = value_count + 1;
                        col_count = 0;
                        next = COL_VALUES;
                    end
                    else begin
                        next = COL_VALUES;
                    end
                end

                else begin
                    next = LOAD_ROW;
                end
            end

            COL_VALUES: begin
                if(col_count < MAT2_COLS) begin
                    result_temp[row_count][col_count] = result_temp[row_count][col_count] + Mat2[offset_value][col_count]*value;
                    col_count = col_count + 1;
                end

                else begin
                    next = ROW_VALUES;
                end
            end

            DONE: begin
                done = 1'b1;
                next = IDLE;
            end

        endcase

    end

    generate
        for(k = MAT1_ROWS - 1; k >= 0; k = k-1) begin : loop5
            for(l = MAT2_COLS ; l >= 1; l = l-1) begin : loop6
                localparam r = (MAT1_ROWS-1) - k;
                localparam c = (MAT2_COLS) - l;
                assign result [(k*RESULT_ROW_SIZE1 + l*ACC_SIZE) - 1 -: ACC_SIZE] = result_temp[r][c];
            end
        end
    endgenerate

endmodule