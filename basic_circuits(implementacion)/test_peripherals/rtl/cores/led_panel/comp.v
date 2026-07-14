module comp#(
  parameter value = 10,
  parameter width = 10
)(
  input [width:0]  in1,
  output  reg       out
);

  always @(*) begin
    if(in1 == value)
      out = 1;
    else
      out = 0;
  end

endmodule