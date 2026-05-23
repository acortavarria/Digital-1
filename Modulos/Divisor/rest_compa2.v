// =============================================================
// Module: rest_compa2
// Guarda el valor de Aext en R cuando la resta es válida
// (Aext >= B). Si la resta no fue válida, R conserva el valor
// anterior — ese valor se usa para restaurar Aext vía LD1.
//
//   LD_R = 1 → guardar Aext_in en R
// =============================================================
module rest_compa2 #(
    parameter N = 8
)(
    input  wire         clk, rst,
    input  wire         LD_R,
    input  wire [N-1:0] Aext_in,
    output reg  [N-1:0] R
);
    always @(posedge clk or posedge rst) begin
        if (rst)       R <= {N{1'b0}};
        else if (LD_R) R <= Aext_in;
    end
endmodule
