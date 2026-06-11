// ============================================================
// s_reg.v  –  Registro de entrada S
// Operaciones: LD (carga paralela), SH_S (shift left 2 bits)
// ============================================================
module s_reg #(parameter N = 8)(
    input  wire         clk,
    input  wire         reset,
    input  wire         LD,       // Carga paralela de S
    input  wire         SH_S,     // Shift izquierda 2 bits
    input  wire [N-1:0] s_in,     // Dato de entrada
    output reg  [N-1:0] s_out     // Contenido del registro
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            s_out <= {N{1'b0}};
        else if (LD)
            s_out <= s_in;
        else if (SH_S)
            s_out <= {s_out[N-3:0], 2'b00};  // shift left 2
    end
endmodule
