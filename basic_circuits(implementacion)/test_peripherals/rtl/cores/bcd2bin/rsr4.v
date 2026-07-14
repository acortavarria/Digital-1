module rsr4 (clk, rst_ld, shift, lda2, in_R1, in_R2, out_R, out_R2);

   input         clk;
   input         rst_ld;
   input         shift;
   input  [4:0]  lda2;
   input  [19:0] in_R1;
   input  [19:0] in_R2;
   output [19:0] out_R;
   output [15:0] out_R2;

   reg [35:0]  data;

assign out_R  = data[35:16];
assign out_R2 = data[15:0];

always @(negedge clk)
  if(rst_ld) begin
    data[15:0]   <= 16'h0000;
    data[35:16]  <= in_R1;
  end
  else
   begin
    if(shift)
      data[35:0] <= {1'b0, data[35:1]} ;
    else begin
      if(lda2[4]==1)
        data[35:32] <= in_R2[19:16];
      if(lda2[3]==1)
        data[31:28] <= in_R2[15:12];
      if(lda2[2]==1)
        data[27:24] <= in_R2[11:8];
      if(lda2[1]==1)
        data[23:20] <= in_R2[7:4];
      if(lda2[0]==1)
        data[19:16] <= in_R2[3:0];
    end 
   end

endmodule
