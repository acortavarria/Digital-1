// ============================================================
// remainder_reg.v  –  Registro del residuo parcial
// Operaciones:
//   LD_SUB : carga el resultado de la resta
//   SH_REM : shift left 2 e inserta s[MSB:MSB-1]
//   reset  : pone a cero
// Ancho: N/2+2 bits (suficiente para rem máximo sin overflow)
// ============================================================
module remainder_reg #(parameter N = 8)(
    input  wire             clk,
    input  wire             reset,
    input  wire             LD_SUB,
    input  wire             SH_REM,
    input  wire [N/2+1:0]   sub_result,
    input  wire [1:0]       s_msb,
    output reg  [N/2+1:0]   rem_out
);
    localparam R = N/2 + 2;

    always @(posedge clk or posedge reset) begin
        if (reset)
            rem_out <= {R{1'b0}};
        else if (SH_REM)
            rem_out <= {rem_out[R-3:0], s_msb};   // shift left 2, entra s_msb
        else if (LD_SUB)
            rem_out <= sub_result;
    end
endmodule
