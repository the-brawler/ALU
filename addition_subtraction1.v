module addition_subtraction1(A, B, Output);
  
input  [31:0] A, B;
output [31:0] Output;

wire [31:0] Output;
wire [7:0] o_e;
wire [24:0] o_m;
  
reg sgA;
reg [7:0] expA;
reg [23:0] manA;
reg sgB;
reg [7:0] expB;
reg [23:0] manB;
reg sgO;
reg [7:0] expO;
reg [24:0] manO;
reg [7:0] difference;
reg [23:0] tempMan;
reg  [7:0] i_e;
reg  [24:0] i_m;

addnorm abc(
    .exp_in(i_e),
    .mantissa_in(i_m),
    .exp_out(o_e),
    .mantissa_out(o_m)
);

assign Output[31] = sgO;
assign Output[30:23] = expO;
assign Output[22:0] = manO[22:0];

always @ ( * ) begin
sgA = A[31];
if(A[30:23] == 0) begin
expA = 8'b00000001;
manA = {1'b0, A[22:0]};
end else begin
expA = A[30:23];
manA = {1'b1, A[22:0]};
end
sgB = B[31];
if(B[30:23] == 0) begin
expB = 8'b00000001;
manB = {1'b0, B[22:0]};
end else begin
expB = B[30:23];
manB = {1'b1, B[22:0]};
end
if (expA == expB) begin
expO = expA;
if (sgA == sgB) begin
manO = manA + manB;
manO[24] = 1;
sgO = sgA;
end else begin
if(manA > manB) begin
manO = manA - manB;
sgO = sgA;
end else begin
manO = manB - manA;
sgO = sgB;
end
end
end else begin 
if (expA > expB) begin
expO = expA;
sgO = sgA;
difference = expA - expB;
tempMan = manB >> difference;
if (sgA == sgB)
manO = manA + tempMan;
else
manO = manA - tempMan;
end else if (expA < expB) begin
expO = expB;
sgO = sgB;
difference = expB - expA;
tempMan = manA >> difference;
if (sgA == sgB) begin
manO = manB + tempMan;
end else begin
manO = manB - tempMan;
end
end
end
if(manO[24] == 1) begin
expO = expO + 1;
manO = manO >> 1;
end else if((manO[23] != 1) && (expO != 0)) begin
i_e = expO;
i_m = manO;
expO = o_e;
manO = o_m;
end
end
endmodule

module addnorm(exp_in,mantissa_in,exp_out,mantissa_out);

input [7:0] exp_in;
input [24:0] mantissa_in;

output [7:0] exp_out;
output [24:0] mantissa_out;

wire [7:0] exp_in;
wire [24:0] mantissa_in;
  
reg [7:0] exp_out;
reg [24:0] mantissa_out;

always @ ( * ) begin
if (mantissa_in[23:3] == 21'b000000000000000000001) begin
    exp_out = exp_in - 20;
    mantissa_out = mantissa_in << 20;
end else if (mantissa_in[23:4] == 20'b00000000000000000001) begin
    exp_out = exp_in - 19;
    mantissa_out = mantissa_in << 19;
end else if (mantissa_in[23:5] == 19'b0000000000000000001) begin
    exp_out = exp_in - 18;
	mantissa_out = mantissa_in << 18;
end else if (mantissa_in[23:6] == 18'b000000000000000001) begin
	exp_out = exp_in - 17;
	mantissa_out = mantissa_in << 17;
end else if (mantissa_in[23:7] == 17'b00000000000000001) begin
	exp_out = exp_in - 16;
	mantissa_out = mantissa_in << 16;
end else if (mantissa_in[23:8] == 16'b0000000000000001) begin
	exp_out = exp_in - 15;
	mantissa_out = mantissa_in << 15;
end else if (mantissa_in[23:9] == 15'b000000000000001) begin
	exp_out = exp_in - 14;
	mantissa_out = mantissa_in << 14;
end else if (mantissa_in[23:10] == 14'b00000000000001) begin
	exp_out = exp_in - 13;
	mantissa_out = mantissa_in << 13;
end else if (mantissa_in[23:11] == 13'b0000000000001) begin
	exp_out = exp_in - 12;
	mantissa_out = mantissa_in << 12;
end else if (mantissa_in[23:12] == 12'b000000000001) begin
	exp_out = exp_in - 11;
	mantissa_out = mantissa_in << 11;
end else if (mantissa_in[23:13] == 11'b00000000001) begin
	exp_out = exp_in - 10;
	mantissa_out = mantissa_in << 10;
end else if (mantissa_in[23:14] == 10'b0000000001) begin
	exp_out = exp_in - 9;
	mantissa_out = mantissa_in << 9;
end else if (mantissa_in[23:15] == 9'b000000001) begin
    exp_out = exp_in - 8;
	mantissa_out = mantissa_in << 8;
end else if (mantissa_in[23:16] == 8'b00000001) begin
	exp_out = exp_in - 7;
	mantissa_out = mantissa_in << 7;
end else if (mantissa_in[23:17] == 7'b0000001) begin
	exp_out = exp_in - 6;
	mantissa_out = mantissa_in << 6;
end else if (mantissa_in[23:18] == 6'b000001) begin
	exp_out = exp_in - 5;
	mantissa_out = mantissa_in << 5;
end else if (mantissa_in[23:19] == 5'b00001) begin
	exp_out = exp_in - 4;
	mantissa_out = mantissa_in << 4;
end else if (mantissa_in[23:20] == 4'b0001) begin
	exp_out = exp_in - 3;
	mantissa_out = mantissa_in << 3;
end else if (mantissa_in[23:21] == 3'b001) begin
	exp_out = exp_in - 2;
	mantissa_out = mantissa_in << 2;
end else if (mantissa_in[23:22] == 2'b01) begin
	exp_out = exp_in - 1;
	mantissa_out = mantissa_in << 1;
end
end
endmodule
