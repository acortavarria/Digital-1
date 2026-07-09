module fsm_raiz (
    input clk,
    input init,
    input reset,
    input Residuo_16,    
    input c,           
    input zz,          
    output reg rst,
    output reg shft,
    output reg agg,
    output reg sumi,
    output reg done
);
    
parameter START  = 0;
parameter SHIFT  = 1;
parameter AGGyLD   = 2;
parameter SUMAR_I   = 3;
parameter DONE   = 4;
parameter ESPERAR   = 5;



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
                   
                    state <= ESPERAR;
            end
                
                ESPERAR: begin
                    if (Residuo_16) 
                        state <= SUMAR_I;
                    else 
                        state <= AGGyLD; 
                end
                
                AGGyLD: begin
                    
                state <= SUMAR_I;
                    end
                SUMAR_I: begin
                    if (c) 
                        state <= DONE;
                    else 
                        state <= SHIFT; 
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
                rst          = 1'b1;
                shft        = 1'b0;
                agg     = 1'b0;
                sumi         = 1'b0;
                done         = 1'b0;
            end
            SHIFT: begin
                rst          = 1'b0;
                shft        = 1'b1;
                agg     = 1'b0;
                sumi         = 1'b0;
                done         = 1'b0;
            end
            AGGyLD: begin
                rst          = 1'b0;
                shft        = 1'b0;
                agg     = 1'b1;
                sumi         = 1'b0;
                done         = 1'b0;
                
            end
            SUMAR_I: begin
                rst          = 1'b0;
                shft        = 1'b0;
                agg     = 1'b0;
                sumi         = 1'b1;
                done         = 1'b0;
                
            end
            DONE: begin
                rst          = 1'b0;
                shft        = 1'b0;
                agg     = 1'b0;
                sumi         = 1'b0;
                done         = 1'b1;
            end
            ESPERAR: begin
                rst          = 1'b0;
                shft        = 1'b0;
                agg     = 1'b0;
                sumi         = 1'b0;
                done         = 1'b0;
            end
            default: begin
                rst          = 1'b0;
                shft        = 1'b0;
                agg     = 1'b0;
                sumi         = 1'b0;
                done         = 1'b0;
            end
        endcase
    end

`ifdef BENCH
    reg [8*6:1] state_name;
    always @(*) begin
        case(state)
            START  : state_name = "START";
            SHIFT : state_name = "SHIFT";
            AGGyLD   : state_name = "AGGyLD";
            SUMAR_I   : state_name = "SUMAR_I";
            DONE   : state_name = "DONE";
            default: state_name = "START";
        endcase
    end
`endif

endmodule