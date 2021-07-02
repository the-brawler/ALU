module alu(clk,A,B,Operator,Result);
input clk;
input [31:0] A,B;
input [2:0] Operator;
output [31:0] Result;
	 
wire [7:0] A_exponent,B_exponent,R_exponent;
wire [23:0] A_mantissa,B_mantissa,R_mantissa;

reg A_sign,B_sign,R_sign;

reg [31:0] A_adder,B_adder;
reg [31:0] A_mult,B_mult;
reg [31:0] A_div,B_div;
reg [31:0] A_and,B_and;
reg [31:0] A_or,B_or;
reg [31:0] A_not;

wire [31:0] Result;
wire [31:0] R_adder;
wire [31:0] R_mult;
wire [31:0] R_div;
wire [31:0] R_and;
wire [31:0] R_or;
wire [31:0] R_not;

assign A_sign = A[31];
assign [7:0] A_exponent = A[30:23];
assign [23:0] A_mantissa = {1'b1, A[22:0]};

assign B_sign = B[31];
assign B_exponent[7:0] = B[30:23];
assign B_mantissa[23:0] = {1'b1, B[22:0]};

assign Result[31] = R_sign;
assign Result[30:23] = R_exponent;
assign Result[22:0] = R_mantissa[22:0];

assign ADD = !Operator[2] & !Operator[1] & !Operator[0];  // 000
assign SUB = !Operator[2] & !Operator[1] &  Operator[0];  // 001
assign DIV = !Operator[2] &  Operator[1] & !Operator[0];  // 010
assign MUL = !Operator[2] &  Operator[1] &  Operator[0];  // 011
assign AND =  Operator[2] & !Operator[1] & !Operator[0];  // 100
assign OR  =  Operator[2] & !Operator[1] &  Operator[0];  // 101
assign NOT =  Operator[2] &  Operator[1] & !Operator[0];  // 110

addsub add1
(
	.A(A_adder),
	.B(B_adder),
	.Output(R_adder)
);

multiplier multiply1
(
	.A(A_mult),
	.B(B_mult),
	.Output(R_mult)
);

divider divide1
(
	.A(A_div),
	.B(B_div),
	.Output(R_div)
);

AND and1
(
	.A(A_and),
	.B(B_and),
	.Output(R_and)
);

OR or1
(
	.A(A_or),
    .B(B_or),
	.Output(R_or)
);

NOT not1
(
	.A(A_not),
	.Output(R_not)
);

always@(posedge clk)
begin	

if (ADD) // adder
begin
	if ((A_exponent == 255 && A_mantissa != 0) || (A_mantissa == 0) && (B_mantissa == 0)) //If A is NaN or B is zero return A
    begin
		R_sign = A_sign;
		R_exponent = A_exponent;
		R_mantissa = A_mantissa;
	end		
	else if ((B_exponent == 255 && B_mantissa != 0) || (A_exponent == 0) && (A_mantissa == 0)) //If B is NaN or A is zero return B
	begin
		R_sign = B_sign;
        R_exponent = B_exponent;
        R_mantissa = B_mantissa;
			
	end 
	else if ((A_exponent == 255) || (B_exponent == 255)) //if A or B is inf return inf
	begin
		R_sign = A_sign ^ B_sign;
		R_exponent = 255;
		R_mantissa = 0;
	end 
	else 
	begin
		A_adder = A;
		B_adder = B;
		R_sign = R_adder[31];
		R_exponent = R_adder[30:23];
		R_mantissa = R_adder[22:0];
	end
end

else if (SUB) // subtractor
begin
	if ((A_exponent == 255 && A_mantissa != 0) || (B_exponent == 0) && (B_mantissa == 0)) //If A is NaN or B is zero return A
	begin
		R_sign = A_sign;
		R_exponent = A_exponent;
		R_mantissa = A_mantissa;
	end 
	else if ((B_exponent == 255 && B_mantissa != 0) || (A_exponent == 0) && (A_mantissa == 0)) //If B is NaN or A is zero return B
	begin
		R_sign = B_sign;
		R_exponent = B_exponent;
		R_mantissa = B_mantissa;
	end 
	else if ((A_exponent == 255) || (B_exponent == 255)) //if A or B is inf return inf
	begin
		R_sign = A_sign ^ B_sign;
		R_exponent = 255;
		R_mantissa = 0;
	end 
	else 
	begin
		A_adder = A;
		B_adder = {~B[31], B[30:0]};
		R_sign = R_adder[31];
		R_exponent = R_adder[30:23];
		R_mantissa = R_adder[22:0];
	end
end		

else if (DIV) // divider
begin
	A_div = A;
	B_div = B;
	R_sign = R_div[31];
	R_exponent = R_div[30:23];
	R_mantissa = R_div[22:0];
end		
else if (MUL) // multiplier
begin
	if (A_exponent == 255 && A_mantissa != 0) //If A is NaN return NaN
	begin
		R_sign = A_sign;
		R_exponent = 255;
		R_mantissa = A_mantissa;
	end 
	else if (B_exponent == 255 && B_mantissa != 0) //If B is NaN return NaN
	begin
		R_sign = B_sign;
		R_exponent = 255;
		R_mantissa = B_mantissa;
	end 
	else if ((A_exponent == 0) && (A_mantissa == 0) || (B_exponent == 0) && (B_mantissa == 0)) //If A or B is 0 return 0
	begin
		R_sign = A_sign ^ B_sign;
		R_exponent = 0;
		R_mantissa = 0;
	end 
	else if ((A_exponent == 255) || (B_exponent == 255)) //if A or B is inf return inf
	begin
		R_sign = A_sign;
		R_exponent = 255;
		R_mantissa = 0;
	end 
	else
	begin
		A_mult = A;
		B_mult = B;
		R_sign = R_mult[31];
		R_exponent = R_mult[30:23];
		R_mantissa = R_mult[22:0];
	end
end		
		
else if (AND) // AND
begin
	A_and = A;
	B_and = B;
	R_sign = R_and[31];
	R_exponent = R_and[30:23];
	R_mantissa = R_and[22:0];
end 

else if (OR) // OR
begin
	A_or = A;
	B_or = B;
	R_sign = R_or[31];
	R_exponent = R_or[30:23];
	R_mantissa = R_or[22:0];
end 

else if (NOT) // NOT
begin
	A_not = A;
	R_sign = R_not[31];
	R_exponent = R_not[30:23];
	R_mantissa = R_not[22:0];
end

end
endmodule