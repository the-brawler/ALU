module Divider(A, B, DivProd);

input [31:0] A,B;
output [31:0] DivProd;
wire [31:0] reci;

NewtonRaphson reciprocal(.B(B),.reci(reci));

MultiTest1 prod(.A(A),.B(reci),.Output(DivProd));

endmodule

module NewtonRaphson(B,reci);

input [31:0] B;
output [31:0] reci;

wire [31:0] r0;
wire [31:0] x1,y1,x2,y2,x3,y3;
wire [31:0] r1,r2,r3;

assign r0=32'b00111111110000000000000000000000;

//first iteration
MultiTest1 r0toD(
    .A(B),
    .B(r0),
    .Output(x1)
);
addition_subtraction twominp1(
    .A(32'b01000000000000000000000000000000),
    .B({~x1[31],x1[30:0]}),
    .Output(y1)
);
MultiTest1 rtoy1(
    .A(r0),
    .B(y1),
    .Output(r1)
);    
//second iteration
MultiTest1 r1toD(
    .A(B),
    .B(r1),
    .Output(x2)
);
addition_subtraction twominp2(
    .A(32'b01000000000000000000000000000000),
    .B({~x2[31],x2[30:0]}),
    .Output(y2)
);
MultiTest1 rtoy2(
    .A(r1),
    .B(y2),
    .Output(r2)
);
//third iteration
MultiTest1 r2toD(
    .A(B),
    .B(r2),
    .Output(x3)
);
addition_subtraction twominp3(
    .A(32'b01000000000000000000000000000000),
    .B({~x3[31],x3[30:0]}),
    .Output(y3)
);
MultiTest1 rtoy3(
    .A(r2),
    .B(y3),
    .Output(r3)
);      
assign reci = r3;
endmodule