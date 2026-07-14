module add_sub_c2 (in_A , in_B, Result);

  input [3:0] in_A;
  input [3:0] in_B;
  output reg [3:0] Result;

always @(*) begin
  Result = in_A + in_B;
end

endmodule
