// =============================================================
// Module: div_shift_register
// Registro de desplazamiento N bits con carga paralela.
//   DIR=1 → left shift  (usado por A REG)
//   DIR=0 → right shift
//   LD    → carga paralela desde D
//   SHFT  → desplaza un bit
//   MSB   → bit más significativo (salida)
// =============================================================
module div_shift_register #(
    parameter N   = 8,
    parameter DIR = 1
)(
    input  wire         clk, rst,
    input  wire         LD, SHFT,
    input  wire [N-1:0] D,
    output reg  [N-1:0] Q,
    output wire         MSB,
    output wire         LSB
);
    assign MSB = Q[N-1];
    assign LSB = Q[0];

    always @(posedge clk or posedge rst) begin
        if (rst)       Q <= {N{1'b0}};
        else if (LD)   Q <= D;
        else if (SHFT) Q <= (DIR==1) ? {Q[N-2:0], 1'b0} : {1'b0, Q[N-1:1]};
    end
endmodule
