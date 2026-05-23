// =============================================================
// Module: div_comparator
// Comparador para el divisor.
//
//   Z     → A == B  (usado: A==0 → fin de división)
//   N_out → A >= B  (usado: Aext >= B → restar)
// =============================================================
module div_comparator #(
    parameter N = 8
)(
    input  wire [N-1:0] A, B,
    output wire         Z,
    output wire         N_out
);
    assign Z     = (A == B);
    assign N_out = (A >= B);
endmodule
