module MultiTest1(A,B,Output);

input [31:0] A;
input [31:0] B;
output [31:0] Output;

reg sgA;
reg sgB;
reg [7:0] expA1;
reg [23:0] manA1;
reg [7:0] expB1;
reg [23:0] manB1;

 reg [31:0] Output;
 reg sgO;
 wire [7:0] expO;
 wire [47:0] manO;

 wire [7:0] in_e;
 wire [47:0] in_m;
 wire [7:0] out_e;
 wire [47:0] out_m;

always @(*) begin
	sgA =A[31];
	expA1 = A[30:23];
	manA1 = {1'b1,A[22:0]};
	sgB =B[31];
	expB1 = B[30:23];
	manB1 = {1'b1,B[22:0]};
end

assign sgO= sgA^sgB;

BinaryAdder BA(
	.expA(expA1),
	.expB(expB1),
	.adduct(in_e)
);

multiplier_MANTISSA MM(
	.manA(manA1),
	.manB(manB1),
	.manO(in_m)
);

multinorm norm2
(
	.exp_in(in_e),
	.mantissa_in(in_m),
	.exp_out(out_e),
	.mantissa_out(out_m)
);
  
assign expO = out_e;
assign manO = out_m;

assign Output[31] = sgO;
assign Output[30:23] = expO;
assign Output[22:0] = manO[45:23];
  
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
assign sum = a ^ b;
assign Cout = a & b;
endmodule

module BinaryAdder(expA,expB,adduct);

input [7:0] expA,expB;
output[7:0] adduct;

wire [7:0] r;
wire [7:0] sum1;
wire[7:0] carr;
wire [8:0] c1;

halfadder f0(.a(expA[0]),.b(expB[0]),.sum(sum1[0]),.Cout(carr[0]));
fulladder f1(.a(expA[1]),.b(expB[1]),.Cin(carr[0]),.sum(sum1[1]),.Cout(carr[1]));
fulladder f2(.a(expA[2]),.b(expB[2]),.Cin(carr[1]),.sum(sum1[2]),.Cout(carr[2]));
fulladder f3(.a(expA[3]),.b(expB[3]),.Cin(carr[2]),.sum(sum1[3]),.Cout(carr[3]));
fulladder f4(.a(expA[4]),.b(expB[4]),.Cin(carr[3]),.sum(sum1[4]),.Cout(carr[4]));
fulladder f5(.a(expA[5]),.b(expB[5]),.Cin(carr[4]),.sum(sum1[5]),.Cout(carr[5]));
fulladder f6(.a(expA[6]),.b(expB[6]),.Cin(carr[5]),.sum(sum1[6]),.Cout(carr[6]));
fulladder f7(.a(expA[7]),.b(expB[7]),.Cin(carr[6]),.sum(sum1[7]),.Cout(carr[7]));

assign c1={carr[7],sum1[7:0]};
assign adduct = c1 - 8'b01111111;
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

module subtractor(sum,d);
input [8:0]sum;
output [7:0] d;
wire borr[8:0];
wire p;

onesub T0 (.s(sum[0]),.out(d[0]),.borrow_in(1'b0),.borrow_out(borr[0]));
onesub T1 (.s(sum[1]),.out(d[1]),.borrow_in(borr[0]),.borrow_out(borr[1]));
onesub T2 (.s(sum[2]),.out(d[2]),.borrow_in(borr[1]),.borrow_out(borr[2]));
onesub T3 (.s(sum[3]),.out(d[3]),.borrow_in(borr[2]),.borrow_out(borr[3]));
onesub T4 (.s(sum[4]),.out(d[4]),.borrow_in(borr[3]),.borrow_out(borr[4]));
onesub T5 (.s(sum[5]),.out(d[5]),.borrow_in(borr[4]),.borrow_out(borr[5]));
onesub T6 (.s(sum[6]),.out(d[6]),.borrow_in(borr[5]),.borrow_out(borr[6]));
zerosub T7(.s(sum[7]),.out(d[7]),.borrow_in(borr[6]),.borrow_out(borr[7]));
zerosub T8(.s(sum[8]),.out(p),.borrow_in(borr[7]),.borrow_out(borr[8]));
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
reg [8:0]AA0,AA1,AA2,BB0,BB1,BB2;
reg [7:0]C1,C2,C3,C4,C5,C6;
wire [15:0]G0,G1,G2;
wire [17:0]G3,G4,G5;
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

assign AA0 = A1 + A0;
assign AA1 = A2 + A0;
assign AA2 = A1 + A2;

assign BB0 = B1 + B0;
assign BB1 = B2 + B0;
assign BB2 = B1 + B2;

multiplier_9bit M3(.X(AA0),.Y(BB0),.Prod(G3));
multiplier_9bit M4(.X(AA1),.Y(BB1),.Prod(G4));
multiplier_9bit M5(.X(AA2),.Y(BB2),.Prod(G5));

assign G0 = G3 - H0 - H1;
assign G1 = G4 - H2 - H0;
assign G2 = G5 - H1 - H2;

assign manO = H2*(33'h2**32) + G2*(25'h2**24) + (G1+H1)*(17'h2**16) + G0*(9'h2**8) + H0;

endmodule 

module multinorm(exp_in,mantissa_in,exp_out,mantissa_out);

input [47:0] mantissa_in;
input [7:0] exp_in;
output [47:0] mantissa_out;
output [7:0] exp_out;

reg [47:0]manti;
reg [7:0]expo;
always @ ( * ) 
begin
if (mantissa_in[47:46] == 2'b01) 
begin
	expo = exp_in;
	manti = mantissa_in;
end 
else if(mantissa_in[47:45] == 3'b001)
begin
	expo = exp_in - 1;
	manti = mantissa_in << 1;
end 
else if(mantissa_in[47] == 1'b1)
begin
	expo = exp_in + 1;
	manti = mantissa_in >> 1;
end
end
assign exp_out = expo;
assign mantissa_out = manti;
endmodule

