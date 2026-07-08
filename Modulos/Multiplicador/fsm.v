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
    
    parameter START    = 0;
    parameter SHIFT    = 1;
    parameter SUMAR    = 2;
    parameter RESTAR   = 3;
    parameter AGREGARC = 4;
    parameter SUMAR_I  = 5;
    parameter SUMAR2   = 6;
    parameter DONE     = 7;

    reg [2:0] state;


    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START: begin
                    if (init) 
                        state <= SHIFT;
                    else 
                        state <= START;
                end
                
                SHIFT: begin
                    if (Aext_16) 
                        state <= SUMAR;
                    else 
                        state <= RESTAR;
                end
                
                SUMAR: begin
                    if (Aext_16) 
                        state <= SUMAR_I;
                    else 
                        state <= AGREGARC;
                end
                
                RESTAR: begin
                    if (Aext_16) 
                        state <= SUMAR_I;
                    else 
                        state <= AGREGARC;
                end
                
                AGREGARC: begin
                    state <= SUMAR_I;
                end
                
                SUMAR_I: begin
                    if (!c) begin
                        state <= SHIFT;
                    end else begin
                        if (Aext_16) 
                            state <= SUMAR2;
                        else 
                            state <= DONE;
                    end
                end
                
                SUMAR2: begin
                    state <= DONE;
                end
                
                DONE: begin
                    if (zz) 
                        state <= START;
                    else 
                        state <= DONE;
                end
                
                default: state <= START;
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            START: begin
                rst    = 1'b1;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            SHIFT: begin
                rst    = 1'b0;
                shft   = 1'b1;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            SUMAR: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b1;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            RESTAR: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b1;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            AGREGARC: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b1;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            SUMAR_I: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b1;
                done   = 1'b0;
            end
            SUMAR2: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b1;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
            DONE: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b1;
            end
            default: begin
                rst    = 1'b0;
                shft   = 1'b0;
                sum    = 1'b0;
                restar = 1'b0;
                agg    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
            end
        endcase
    end

`ifdef BENCH
    reg [8*10:1] state_name;
    always @(*) begin
        case(state)
            START    : state_name = "START";
            SHIFT    : state_name = "SHIFT";
            SUMAR    : state_name = "SUMAR";
            RESTAR   : state_name = "RESTAR";
            AGREGARC : state_name = "AGREGARC";
            SUMAR_I  : state_name = "SUMAR_I";
            SUMAR2   : state_name = "SUMAR2";
            DONE     : state_name = "DONE";
            default  : state_name = "START";
        endcase
    end
`endif

endmodule