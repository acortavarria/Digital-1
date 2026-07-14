module addc2 (in_A , in_B, Result);

  input [15:0] in_A;
  input [15:0] in_B;  
  output reg [15:0] Result;

always @(*) begin
  Result = in_A + (~in_B)+1;
end

endmodule
