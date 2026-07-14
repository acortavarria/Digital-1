module reg_msb (clk , reset, in, out, ld, oe);

  input             clk;
  input             reset;
  input             ld;
  input             oe;
  input      [4:0]  in;
  output reg    [4:0]  out;

  reg [4:0] cont;



always @(*) begin
  if(oe)
    out = ~cont;
  else
    out = 0;
end


always @(negedge clk) begin
  if (reset) begin
    cont  <= 0;
  end
  else begin
    if ( ld )
      cont  <= in;
  end
end

endmodule
