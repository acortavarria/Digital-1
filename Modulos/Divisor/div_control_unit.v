// =============================================================
// Module: div_control_unit
// FSM del divisor restoring.
//
// Estados (según diagrama):
//   START     : LD=1  — cargar A,B; limpiar Aext,C,R
//   SHIFT     : SHFT=1 — shift left {Aext,A}, bit cociente=0
//   ADD_Y_LOAD: ADD=1, LD1=1 — Aext-B y guardar; bit cociente=1
//   SHFT1     : SHFT1=1 — shift C con 1 (bit cociente ya fue 1)
//   CHECK     : evaluar Z (A==0 → fin)
//   END       : DONE=1
//
// Transiciones:
//   START → si N=1 (Aext>=B): ADD_Y_LOAD; si N=0: SHIFT
//   ADD_Y_LOAD → SHFT1
//   SHFT1 → CHECK
//   SHIFT → CHECK
//   CHECK → si Z=1: END; si N=1: ADD_Y_LOAD; si N=0: SHIFT
// =============================================================
module div_control_unit (
    input  wire clk, rst, start,
    input  wire N_in,   // Aext >= B
    input  wire Z,      // A  == 0  (fin)
    output reg  LD,
    output reg  ADD,
    output reg  SHFT,
    output reg  SHFT1,
    output reg  LD1,
    output reg  DONE
);
    localparam [2:0]
        S_START      = 3'd0,
        S_SHIFT      = 3'd1,
        S_ADD_Y_LOAD = 3'd2,
        S_SHFT1      = 3'd3,
        S_CHECK      = 3'd4,
        S_END        = 3'd5;

    reg [2:0] state, next;

    always @(posedge clk or posedge rst)
        if (rst) state <= S_START;
        else     state <= next;

    always @(*) begin
        next = state;
        case (state)
            S_START:      if (start) next = N_in ? S_ADD_Y_LOAD : S_SHIFT;
            S_ADD_Y_LOAD:            next = S_SHFT1;
            S_SHFT1:                 next = S_CHECK;
            S_SHIFT:                 next = S_CHECK;
            S_CHECK: begin
                if (Z)               next = S_END;
                else                 next = N_in ? S_ADD_Y_LOAD : S_SHIFT;
            end
            S_END:                   next = S_END;
            default:                 next = S_START;
        endcase
    end

    always @(*) begin
        LD=0; ADD=0; SHFT=0; SHFT1=0; LD1=0; DONE=0;
        case (state)
            S_START:      LD              = 1;
            S_ADD_Y_LOAD: begin ADD=1; LD1=1; end
            S_SHIFT:      SHFT            = 1;
            S_SHFT1:      SHFT1           = 1;
            S_END:        DONE            = 1;
        endcase
    end
endmodule
