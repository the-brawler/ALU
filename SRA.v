module SRA(A,n, Output);
input[31:0]A;
input n;

output reg[31:0]Output;

always@(A)
         Output = A >>> n;
endmodule
