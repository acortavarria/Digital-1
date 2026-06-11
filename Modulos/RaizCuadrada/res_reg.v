// ============================================================
// res_reg.v  –  Registro del resultado (raíz cuadrada parcial)
// Operaciones: reset, SH_RES (shift left 1 + bit nuevo)
// ============================================================
module res_reg #(parameter N = 8)(
    input  wire             clk,
    input  wire             reset,
    input  wire             SH_RES,       // Shift left 1 e inserta replacing_bit
    input  wire             replacing_bit,// Bit que entra por la derecha (0 ó 1)
    output reg  [N/2-1:0]   res_out       // Resultado parcial (N/2 bits)
);
    localparam R = N/2;

    always @(posedge clk or posedge reset) begin
        if (reset)
            res_out <= {R{1'b0}};
        else if (SH_RES)
            res_out <= {res_out[R-2:0], replacing_bit};  // shift left + nuevo bit
    end
endmodule
