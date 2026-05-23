// =============================================================
// Module: divider  (top-level)
// Divisor binario Restoring (shift-and-subtract).
//
//   Q_out = cociente  (N bits)
//   R_out = resto     (N bits)
//
// Algoritmo (por ciclo de hardware):
//   1. SHIFT: {Aext,A} << 1  (MSB de A entra al LSB de Aext)
//   2. Comparar Aext vs B:
//      - Aext >= B (N=1): Aext = Aext-B, bit cociente=1 → ADD_Y_LOAD
//      - Aext < B  (N=0): restaurar, bit cociente=0   → SHIFT
//   3. Si A == 0: FIN
//
// NOTA: El top-level usa el módulo behavioral `divider` de una
// sola FSM implícita (contador) que refleja el mismo datapath
// del diagrama. Los submódulos individuales están disponibles
// por separado para síntesis estructural.
// =============================================================


module divider #(parameter N = 8)(
    input  wire         clk, rst, start,
    input  wire [N-1:0] A_in,
    input  wire [N-1:0] B_in,
    output wire [N-1:0] Q_out,
    output wire [N-1:0] R_out,
    output wire         done
);
    // Señales de control
    wire LD, ADD, SHFT, SHFT1, LD1;

    // Señales del datapath
    wire [N-1:0] A_q;          // Registro A (dividendo → cociente)
    wire [N-1:0] Aext_q;       // Registro Aext (resto parcial)
    wire [N-1:0] B_q;          // Registro B (divisor)
    wire [N-1:0] C_q;          // Registro C (cociente)
    wire [N-1:0] R_saved;      // Valor guardado para restaurar
    wire         A_MSB;        // MSB de A → entra a Aext al shiftear
    wire         A_ZERO;       // A == 0 → fin
    wire         Aext_geq_B;   // Aext >= B → restar

    // ---- A REG: dividendo con left-shift ----
    div_shift_register #(.N(N), .DIR(1)) A_REG (
        .clk(clk), .rst(rst),
        .LD(LD), .SHFT(SHFT | SHFT1),
        .D(A_in),
        .Q(A_q),
        .MSB(A_MSB), .LSB()
    );

    // ---- B REG: divisor (solo carga, sin shift) ----
    div_shift_register #(.N(N), .DIR(1)) B_REG (
        .clk(clk), .rst(rst),
        .LD(LD), .SHFT(1'b0),
        .D(B_in),
        .Q(B_q),
        .MSB(), .LSB()
    );

    // ---- Aext REG: resto parcial ----
    aext_reg #(.N(N)) AEXT_REG (
        .clk(clk), .rst(rst),
        .LD(LD),
        .SHFT(SHFT | SHFT1),
        .SUB(ADD),
        .LD1(LD1 & ~ADD),   // restaurar solo si no se restó
        .A_MSB(A_MSB),
        .B(B_q),
        .R(R_saved),
        .Q(Aext_q)
    );

    // ---- REG C: cociente ----
    reg_c #(.N(N)) C_REG (
        .clk(clk), .rst(rst),
        .LD(LD),
        .SHFT(SHFT),
        .SHFT1(SHFT1),
        .Q(C_q)
    );

    // ---- COMP1: Aext >= B ----
    div_comparator #(.N(N)) COMP1 (
        .A(Aext_q), .B(B_q),
        .Z(), .N_out(Aext_geq_B)
    );

    // ---- COMP2: A == 0 (fin) ----
    div_comparator #(.N(N)) COMP2 (
        .A(A_q), .B({N{1'b0}}),
        .Z(A_ZERO), .N_out()
    );

    // ---- Rest compa2: guarda Aext cuando resta válida ----
    rest_compa2 #(.N(N)) REST2 (
        .clk(clk), .rst(rst),
        .LD_R(Aext_geq_B & ADD),
        .Aext_in(Aext_q),
        .R(R_saved)
    );

    // ---- FSM de control ----
    div_control_unit FSM (
        .clk(clk), .rst(rst), .start(start),
        .N_in(Aext_geq_B), .Z(A_ZERO),
        .LD(LD), .ADD(ADD), .SHFT(SHFT), .SHFT1(SHFT1), .LD1(LD1),
        .DONE(done)
    );

    assign Q_out = C_q;
    assign R_out = Aext_q;
endmodule
