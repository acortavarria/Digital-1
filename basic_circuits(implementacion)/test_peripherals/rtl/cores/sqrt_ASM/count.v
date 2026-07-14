module count (clk , ld, dec, z);

  input clk;
  input ld;
  input dec;
  output reg z;

  reg [3:0] cont=8;


always @(negedge clk) begin
  if (ld) 
    cont  <= 4'b1000; //8
  else begin
    if (dec) 
      cont  <= cont-1;
    else
      cont  <= cont;
  end
  z = (cont==0) ? 1 : 0 ;
end

endmodule
