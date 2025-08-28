`timescale 1ns / 1ps

module multiplier(
        input [DATA_WIDTH-1:0] B,
        input [DATA_WIDTH-1:0] C,
        output [ACC_WIDTH-1:0] Product
    );
    
    assign Product = B*C;
endmodule