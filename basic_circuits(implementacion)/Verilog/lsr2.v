module lsr2 (clk, rst_ld, shift, lda2, in_R1, in_R2, out_R);
   input         clk;
   input         rst_ld;
   input         shift;
   input         lda2;   
   input [3:0]  in_R1;
   input [3:0]  in_R2;
   output [3:0] out_R;

   reg [7:0]  data;

assign out_R = data[7:4];

always @(negedge clk)
  if(rst_ld) begin
    data[7:4] <= 4'h0;
    data[3:0]  <= in_R1;
  end
  else
   begin
    if(shift)
      data[7:0] <= {data[5:0], 2'b00} ;
    if(lda2)
      data[7:4] <= in_R2;
   end

endmodule
