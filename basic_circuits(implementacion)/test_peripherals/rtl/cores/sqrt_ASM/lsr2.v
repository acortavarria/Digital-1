module lsr2 (clk, rst_ld, shift, lda2, in_R1, in_R2, out_R);
   input         clk;
   input         rst_ld;
   input         shift;
   input         lda2;   
   input [15:0]  in_R1;
   input [15:0]  in_R2;
   output [15:0] out_R;

   reg [31:0]  data;

assign out_R = data[31:16];

always @(negedge clk)
  if(rst_ld) begin
    data[31:16] <= 16'h0000;
    data[15:0]  <= in_R1;
  end
  else
   begin
    if(shift)
      data[31:0] <= {data[29:0], 2'b00} ;
    if(lda2)
      data[31:16] <= in_R2;
   end

endmodule
