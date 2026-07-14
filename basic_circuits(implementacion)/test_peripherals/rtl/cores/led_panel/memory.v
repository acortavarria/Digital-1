module memory(
  input             clk,
  input  [10:0]     address,
  input             rd,
  output reg [5:0]  rdata
);

reg [5:0] MEM [0:2047];
initial begin
    $readmemh("./image.hex",MEM);
end

  always @(negedge clk) begin
    if(rd) begin
        rdata <= MEM[address];     //{RGB0,RGB1}
    end
  end

endmodule
