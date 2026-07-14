module comp(B, z);
  input [15:0]B;
  output reg z;

  always@(*)
    if (B==0)
      z <= 1;
    else
      z <= 0;

endmodule
