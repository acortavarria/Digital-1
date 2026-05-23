// =============================================================
// Module: aext_reg
// Registro Aext — resto parcial del divisor.
//
//   LD    → limpiar a 0 (inicialización)
//   SHFT  → shift left; el MSB de A entra por el LSB
//           {Aext[N-2:0], A_MSB}
//   SUB   → Aext = Aext - B  (resta, si resultado >= 0)
//   LD1   → restaurar Aext desde R (resultado < 0, restaurar)
// =============================================================
module aext_reg #(
    parameter N = 8
)(
    input  wire         clk, rst,
    input  wire         LD,     // clear
    input  wire         SHFT,   // shift left + entrada A_MSB
    input  wire         SUB,    // Aext = Aext - B
    input  wire         LD1,    // Aext = R (restaurar)
    input  wire         A_MSB,  // bit que entra al shiftear
    input  wire [N-1:0] B,      // divisor
    input  wire [N-1:0] R,      // valor guardado para restaurar
    output reg  [N-1:0] Q
);
    always @(posedge clk or posedge rst) begin
        if (rst)       Q <= {N{1'b0}};
        else if (LD)   Q <= {N{1'b0}};
        else if (SHFT) Q <= {Q[N-2:0], A_MSB};
        else if (SUB)  Q <= Q - B;
        else if (LD1)  Q <= R;
    end
endmodule
