module lsr (clk , in_A , shift , load , s_A);
  input clk;
  input [4:0]in_A;
  input load;
  input shift;
  output reg [4:0]s_A;

always @(negedge clk)
  if(load)
     s_A = in_A ;
  else
   begin
    if(shift)
//      s_A <= s_A << 1 ;
      s_A[4:0] <= {s_A[3:0], 1'b0};
    else
      s_A <= s_A;
   end

endmodule
