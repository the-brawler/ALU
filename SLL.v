module SLL(A,n, Output);
input[31:0]A;
input [5:0]n;

output reg[31:0]Output;

always@(*)
         Output = A << n;
endmodule
