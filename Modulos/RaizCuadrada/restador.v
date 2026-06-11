// ============================================================
// restador.v  –  Sustractor combinacional
// Calcula: remainder - {res, 2'b01}
// ============================================================
module restador #(parameter N = 8)(
    input  wire [N/2+1:0]  remainder,
    input  wire [N/2-1:0]  res,
    output wire [N/2+1:0]  diff
);
    wire [N/2+1:0] subtrahend = {{2{1'b0}}, res, 1'b0, 1'b1};  // {0,0,res,2'b01}
    assign diff = remainder - subtrahend;
endmodule
