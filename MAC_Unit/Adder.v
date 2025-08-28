`timescale 1ns / 1ps

module adder(
        input [ACC_WIDTH-1:0] Product,
        input [ACC_WIDTH-1:0] Ain,
        output [ACC_WIDTH-1:0] Aout
    );
    
    assign Aout = Ain + Product;
endmodule