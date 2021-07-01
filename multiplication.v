module multiplication(A,B,Output);

input [31:0] A;
input [31:0] B;
output [31:0] Output;

reg sgA;
reg sgB;
reg [7:0] expA;
reg [23:0] manA;
reg [7:0] expB;
reg [23:0] manB;

 wire [31:0] Output;
 reg sgO;
 reg [7:0] expO;
 reg [24:0] manO;

 reg [47:0]Pdt;
 reg  [7:0] in_e;
 reg  [47:0] in_m;
 wire [7:0] out_e;
 wire [47:0] out_m;

assign Output[31] = sgO;
assign Output[30:23] = expO;
assign Output[22:0] = manO[22:0];

multinorm norm2
  (
	.in_e(in_e),
	.in_m(in_m),
	.out_e(out_e),
	.out_m(out_m)
  );
endmodule

module fulladder(
input a,b,Cin,
output sum,Cout );
wire gate1, gate2, gate3;
xor(gate1,a,b);
xor(sum,gate1,Cin);
and(gate3,a,b);
and(gate2,gate1,Cin);
or(Cout,gate2,gate3);
endmodule

module halfadder(
input a,b,
output sum,Cout);
xor(sum,a,b);
and(Cout,a,b);
endmodule

module BinaryAdder(
input [7:0]expA,expB,
output[7:0] sum,
output Cout);
wire[7:0] carr;

halfadder f0(.a(expA[0]),
.b(expB[0]),.sum(sum[0]),.Cout(carr[0]));
fulladder f1(.a(expA[1]),
.b(expB[1]),.Cin(carr[0]),.sum(sum[1]),.Cout(carr[1]));
fulladder f2(.a(expA[2]),
.b(expB[2]),.Cin(carr[1]),.sum(sum[2]),.Cout(carr[2]));
fulladder f3(.a(expA[3]),
.b(expB[3]),.Cin(carr[2]),.sum(sum[3]),.Cout(carr[3]));
fulladder f4(.a(expA[4]),
.b(expB[4]),.Cin(carr[3]),.sum(sum[4]),.Cout(carr[4]));
fulladder f5(.a(expA[5]),
.b(expB[5]),.Cin(carr[4]),.sum(sum[5]),.Cout(carr[5]));
fulladder f6(.a(expA[6]),
.b(expB[6]),.Cin(carr[5]),.sum(sum[6]),.Cout(carr[6]));
fulladder f7(.a(expA[7]),
.b(expB[7]),.Cin(carr[6]),.sum(sum[7]),.Cout(carr[7]));
subtractor sub1(.sum(sum),.carry(carr[7]),.d(expO));
endmodule

module onesub(s,out,borrow_in,borrow_out);
input s,borrow_in;
output out,borrow_out;
reg out,borrow_out;
reg s1;
assign s1=s;
always@(*)
begin
s1 = s1-borrow_in;
out = s1-1;
if(s1 ==0) 
borrow_out =1;
else
borrow_out =0;
end
endmodule

module zerosub(s,out,borrow_in,borrow_out);
input s,borrow_in;
output out,borrow_out;
reg out,borrow_out;
reg s2;
assign s2=s;
always@(*)
begin
out = s2-0;
if(s2==1)
borrow_out =0;
end
endmodule

module subtractor(sum,carry,d);
input [7:0]sum;
input carry;
output d[7:0];
wire borr[8:0];
reg p;

onesub T0 (.s(sum[0]),.out(d[0]),.borrow_in(0),.borrow_out(borr[0]));
onesub T1 (.s(sum[1]),.out(d[1]),.borrow_in(borr[0]),.borrow_out(borr[1]));
onesub T2 (.s(sum[2]),.out(d[2]),.borrow_in(borr[1]),.borrow_out(borr[2]));
onesub T3 (.s(sum[3]),.out(d[3]),.borrow_in(borr[2]),.borrow_out(borr[3]));
onesub T4 (.s(sum[4]),.out(d[4]),.borrow_in(borr[3]),.borrow_out(borr[4]));
onesub T5 (.s(sum[5]),.out(d[5]),.borrow_in(borr[4]),.borrow_out(borr[5]));
onesub T6 (.s(sum[6]),.out(d[6]),.borrow_in(borr[5]),.borrow_out(borr[6]));
zerosub T7(.s(sum[7]),.out(d[7]),.borrow_in(borr[6]),.borrow_out(borr[7]));
zerosub T8(.s(carry),.out(p),.borrow_in(borr[7]),.borrow_out(borr[8]));
endmodule

module multiplier_8bit(X,Y,Prod);
input [7:0]X,Y;
output [15:0]Prod;
assign Prod = X*Y;
endmodule

module multiplier_9bit(X,Y,Prod);
input [8:0]X,Y;
output [17:0]Prod;
assign Prod = X*Y;
endmodule


module multiplier_MANTISSA(manA,manB,manO);
input [23:0]manA,manB;
output [47:0]manO;

reg [7:0]A0,A1,A2,B0,B1,B2;
wire [17:0]G0,G1,G2;
wire [15:0]H0,H1,H2;
assign A0 = manA[7:0];
assign A1 = manA[15:8];
assign A2 = manA[23:16];

assign B0 = manB[7:0];
assign B1 = manB[15:8];
assign B2 = manB[23:16]; 

multiplier_8bit M0(.X(A0),.Y(B0),.Prod(H0));
multiplier_8bit M1(.X(A1),.Y(B1),.Prod(H1));
multiplier_8bit M2(.X(A2),.Y(B2),.Prod(H2));


multilpier_9bit M3(.X(A1 + A0),.Y(B1 + B0),.Prod(G0));
multilpier_9bit M4(.X(A2 + A0),.Y(B2 + B0),.Prod(G1));
multilpier_9bit M5(.X(A1 + A2),.Y(B1 + B2),.Prod(G2));

assign G0 = G0 - H0 - H1;
assign G1 = G1 - H2 - H0;
assign G2 = G2 - H1 - H2;

assign manO = H2*(33'h2**32) + G2*(25'h2**24) + (G1+H1)*(17'h2**16) + G0*(9'h2**8) + H0;
endmodule
