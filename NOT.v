module NOT(A, Output);
input[31:0]A;

output reg[31:0]Output;

always@(A)
         Output = ~A;
endmodule
