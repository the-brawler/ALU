`timescale 1ns / 1ps
module Divider(A, B, DivProd);

input [31:0] A,B;
output [31:0] DivProd;

reg s_A,s_B,s_O;
reg [7:0] exp_A,exp_B,exp_O;
reg [23:0] man_A,man_B,man_O;
reg [47:0] r1,r2,r3,r0;

assign DivProd[31]=s_O;
assign DivProd[30:23]=exp_O;
assign DivProd[22:0]=man_O;

always@(*)
begin

s_A=A[31];
s_B=B[31];
exp_A=A[30:23];
exp_B=B[30:23];
man_A={1'b1,A[22:0]};
man_B={1'b1,B[22:0]};

exp_O=exp_A-exp_B+8'b01111111;
s_O=s_A ^ s_B;

r0=48'b001001110101110001010010001001110101110001010010;
r1=r0 * (48'd2 - (r0*man_B));
r2=r1 * (48'd2 - (r1*man_B));
r3=r2 * (48'd2 - (r2*man_B));
r3=r3*man_A;

man_O=r3[46:23];
end
endmodule

