// ============================================================
// control_fsm.v  –  Máquina de Control (FSM)
// Estados: START, REMS, CHECKREM, RES1, RES0, CHECKCOUNT, END
// Entradas:  v (comparador remainder), z (contador == 0)
// Salidas:   LD, SUBR, SH_REM, SH_RES, DECC, SH_S, replacing_bit
// ============================================================
module control_fsm (
    input  wire clk,
    input  wire reset,
    input  wire init,         // Pulso de inicio
    input  wire v,            // remainder >= {res,2'b01}
    input  wire z,            // count == 0
    // Señales de control al datapath
    output reg  LD,
    output reg  SUBR,
    output reg  SH_REM,
    output reg  SH_RES,
    output reg  DECC,
    output reg  SH_S,
    output reg  replacing_bit,
    output reg  done
);

    // Codificación de estados
    localparam [2:0]
        START      = 3'd0,
        REMS       = 3'd1,
        CHECKREM   = 3'd2,
        RES1       = 3'd3,
        RES0       = 3'd4,
        CHECKCOUNT = 3'd5,
        END_ST     = 3'd6;

    reg [2:0] state, next_state;

    // ── Registro de estado ────────────────────────────────
    always @(posedge clk or posedge reset) begin
        if (reset) state <= START;
        else       state <= next_state;
    end

    // ── Lógica de próximo estado ──────────────────────────
    always @(*) begin
        case (state)
            START:      next_state = init     ? REMS       : START;
            REMS:       next_state = CHECKREM;
            CHECKREM:   next_state = v        ? RES1       : RES0;
            RES1:       next_state = CHECKCOUNT;
            RES0:       next_state = CHECKCOUNT;
            CHECKCOUNT: next_state = z        ? END_ST     : REMS;
            END_ST:     next_state = END_ST;
            default:    next_state = START;
        endcase
    end

    // ── Salidas (Moore) ───────────────────────────────────
    always @(*) begin
        // Defaults: todo a 0
        LD            = 1'b0;
        SUBR          = 1'b0;
        SH_REM        = 1'b0;
        SH_RES        = 1'b0;
        DECC          = 1'b0;
        SH_S          = 1'b0;
        replacing_bit = 1'b0;
        done          = 1'b0;

        case (state)
            START: begin
                LD     = 1'b1;  // Carga S y resetea registros
                // SUBR=0, SH_REM=0, SH_RES=0, DECC=0, SH_S=0
            end

            REMS: begin
                SH_REM = 1'b1;  // Shift remainder << 2 con bits MSB de S
                SH_S   = 1'b1;  // Shift S << 2
            end

            CHECKREM: begin
                // Solo evaluación combinacional de v; no hay señales activas
            end

            RES1: begin
                SUBR          = 1'b1;  // Resta: remainder = remainder - {res,2'b01}
                SH_RES        = 1'b1;  // res = (res<<1) | 1
                replacing_bit = 1'b1;
            end

            RES0: begin
                SH_RES        = 1'b1;  // res = (res<<1) | 0
                replacing_bit = 1'b0;
            end

            CHECKCOUNT: begin
                DECC = 1'b1;  // count--
            end

            END_ST: begin
                done = 1'b1;
            end
        endcase
    end

endmodule
