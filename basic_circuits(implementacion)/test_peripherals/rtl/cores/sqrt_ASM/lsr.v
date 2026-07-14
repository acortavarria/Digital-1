module lsr (clk , reset,  shift , load , load_R0, in_bit, in_A , out_r);

  input             clk;
  input             reset;
  input             shift;
  input             load;
  input             load_R0;
  input             in_bit;
  input [15:0]      in_A;
  output reg [15:0] out_r;

always @(negedge clk)
  if(reset)
    out_r <= 16'h0 ;
  else
    begin
      if(load) 
        out_r       <= in_A ;
      if(shift)
        out_r[15:0] <= {out_r[14:0], 1'b0};
      if(load_R0)
        out_r[15:0] <= {out_r[15:1], in_bit};
  end
endmodule
