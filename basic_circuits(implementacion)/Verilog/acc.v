module acc (clk , A, add, rst, pp);
  input clk;
  input [3:0] A;
  input add;
  input rst;
  output reg [3:0] pp;

initial pp = 0;

always @(negedge clk)
  if (rst)
   pp <= 4'h0;
  else
     begin
      if (add)
        pp <= pp + A;
      else
        pp <= pp;
     end
endmodule
