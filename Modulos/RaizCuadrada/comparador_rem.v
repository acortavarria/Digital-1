// ============================================================
// comparador_rem.v  –  Comparador del residuo
// Verifica: remainder >= {res, 2'b01}
// ============================================================
module comparador_rem #(parameter N = 8)(
    input  wire [N/2+1:0]  remainder,
    input  wire [N/2-1:0]  res,
    output wire            v
);
    wire [N/2+1:0] threshold = {{2{1'b0}}, res, 1'b0, 1'b1};
    assign v = (remainder >= threshold);
endmodule
