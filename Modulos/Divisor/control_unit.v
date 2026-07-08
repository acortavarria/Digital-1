module fsm_divisor (
    input clk,
    input init,
    input reset,
    input Aext_16,       
    input c,             
    input zz,            
    output reg rst,
    output reg shft,
    output reg sum,
    output reg restar,
    output reg agg,
    output reg sumi,
    output reg done
);
    reg [2:0] state, next_state;
    
    localparam START    = 3'b000,
               SHIFT    = 3'b001,
               SUMAR    = 3'b010,
               RESTAR   = 3'b011,
               AGREGARC = 3'b100,
               SUMAR_I  = 3'b101,
               SUMAR2   = 3'b110,
               DONE     = 3'b111;

    always @(*) begin
        next_state = state;
        case (state)
            START:    next_state = (init) ? SHIFT : START;
            SHIFT:    next_state = (Aext_16) ? SUMAR : RESTAR;
            SUMAR:    next_state = (Aext_16) ? SUMAR_I : AGREGARC;
            RESTAR:   next_state = (Aext_16) ? SUMAR_I : AGREGARC;
            AGREGARC: next_state = SUMAR_I;
            SUMAR_I:  if (~c) 
                          next_state = SHIFT;
                      else 
                          next_state = (Aext_16) ? SUMAR2 : DONE;
            SUMAR2:   next_state = DONE;
            DONE:     next_state = (zz) ? START : DONE;
            default:  next_state = START;
        endcase
    end

    // CORREGIDO: Ahora corre en posedge clk igual que los registros
    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        rst = 0; shft = 0; sum = 0; restar = 0; agg = 0; sumi = 0; done = 0;
        case (state)
            START:    rst = 1;
            SHIFT:    shft = 1;
            SUMAR:    sum = 1;
            RESTAR:   restar = 1;
            AGREGARC: agg = 1;
            SUMAR_I:  sumi = 1;
            SUMAR2:   sum = 1;
            DONE:     done = 1;
        endcase
    end
endmodule