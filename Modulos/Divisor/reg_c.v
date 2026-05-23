// =============================================================
// Module: reg_c
// Registro C — almacena el cociente bit a bit.
//
//   LD    → clear a 0
//   SHFT  → shift left, entra 0 (Aext < B, bit cociente = 0)
//   SHFT1 → shift left, entra 1 (Aext >= B, bit cociente = 1)
// =============================================================
module reg_c #(
    parameter N = 8
)(
    input  wire         clk, rst,
    input  wire         LD, SHFT, SHFT1,
    output reg  [N-1:0] Q
);
    always @(posedge clk or posedge rst) begin
        if (rst)        Q <= {N{1'b0}};
        else if (LD)    Q <= {N{1'b0}};
        else if (SHFT1) Q <= {Q[N-2:0], 1'b1};
        else if (SHFT)  Q <= {Q[N-2:0], 1'b0};
    end
endmodule
