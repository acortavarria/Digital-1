// ============================================================
// contador.v  –  Contador de iteraciones
// Cargado con N/2 al inicio (LD), decrementado con DECC
// Señal z=1 cuando count llegará a 0 en este ciclo (count==1 y DECC=1)
// o cuando ya es 0
// ============================================================
module contador #(parameter N = 8)(
    input  wire             clk,
    input  wire             reset,
    input  wire             LD_CNT,       // Carga valor inicial (N/2)
    input  wire             DECC,         // Decrementa en 1
    output wire             z             // 1 cuando count == 0 (post-decremento)
);
    localparam BITS = $clog2(N/2 + 1);
    localparam [BITS-1:0] INIT_VAL = N/2;

    reg [BITS-1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= {BITS{1'b0}};
        else if (LD_CNT)
            count <= INIT_VAL;
        else if (DECC && count != 0)
            count <= count - 1'b1;
    end

    // z anticipado: si vamos a decrementar y count es 1, la próxima será 0
    assign z = (count == 0) || (DECC && (count == 1));
endmodule
