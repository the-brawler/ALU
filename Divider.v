`timescale 1ns / 1ps
module Divider(A, B, DivProd);

input [31:0] A,B;
output [31:0] DivProd;
wire [31:0] reci;

NewtonRaphson reciprocal(.B(B),.reci(reci));

mutiplication prod(.A(A),.B(reci),.Output(DivProd));

endmodule
