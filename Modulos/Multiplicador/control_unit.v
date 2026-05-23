// =============================================================
// Module: control_unit  (FSM final corregida)
// El flowchart correcto es:
//   START → leer B_LSB → si 1: R=R+A → shift A<<1, B>>1 → si B=0: DONE
// Por tanto el orden de estados es:
//   START → CHECK → ADD (opcional) → SHIFT → CHECK → ... → END
// CHECK evalúa B_LSB *antes* de shiftear.
// =============================================================
module control_unit (
    input  wire clk, rst, start,
    input  wire B_LSB,
    input  wire B_ZERO,
    output reg  LD, SHFT, ADD, DONE
);
    localparam [2:0]
        S_START = 3'd0,
        S_CHECK = 3'd1,   // evaluar B_LSB (sin shift aún)
        S_ADD   = 3'd2,   // R = R + A
        S_SHIFT = 3'd3,   // A<<1, B>>1
        S_END   = 3'd4;

    reg [2:0] state, next;

    always @(posedge clk or posedge rst)
        if (rst) state <= S_START;
        else     state <= next;

    always @(*) begin
        next = state;
        case (state)
            S_START: if (start)  next = S_CHECK;
            S_CHECK: if (B_LSB)  next = S_ADD;
                     else        next = S_SHIFT;
            S_ADD:               next = S_SHIFT;
            S_SHIFT: if (B_ZERO) next = S_END;
                     else        next = S_CHECK;
            S_END:               next = S_END;
        endcase
    end

    always @(*) begin
        LD=0; SHFT=0; ADD=0; DONE=0;
        case (state)
            S_START: LD   = 1;
            S_ADD:   ADD  = 1;
            S_SHIFT: SHFT = 1;
            S_END:   DONE = 1;
        endcase
    end
endmodule
