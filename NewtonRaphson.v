`timescale 1ns / 1ps
module NewtonRaphson(B,reci);

input [31:0] B;
output [31:0] reci;

wire r0[31:0]=32'b00111111000110011001100110011010;
wire [31:0] x1,y1,x2,y2,x3,y3;
wire [31:0] r1,r2,r3;

//first iteration
multiplication r0toD(
    .A(B),
    .B(r0),
    .Output(x1)
);
assign x1=~x1;
adder twominp1(
    .A(32'd2),
    .B(x1),
    .Output(y1)
);
multiplication rtoy1(
    .A(r0),
    .B(y1),
    .Output(r1)
);    
//second iteration
multiplication r1toD(
    .A(B),
    .B(r1),
    .Output(x2)
);
assign x2=~x2;
adder twominp2(
    .A(32'd2),
    .B(x2),
    .Output(y2)
);
multiplication rtoy2(
    .A(r1),
    .B(y2),
    .Output(r2)
);
//third iteration
multiplication r2toD(
    .A(B),
    .B(r2),
    .Output(x3)
);
assign x3=~x3;
adder twominp3(
    .A(32'd2),
    .B(x3),
    .Output(y3)
);
multiplication rtoy3(
    .A(r2),
    .B(y3),
    .Output(r3)
);      
assign reci = r3;
endmodule
