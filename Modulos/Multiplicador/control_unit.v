module fsm_multiplicador (
    input clk,
    input reset,
    input init,
    input A_i,      
    input c,       
    input zz,
    output reg rst,
    output reg sum,
    output reg sumi,
    output reg done,
    output reg shft
);

    
    parameter START   = 0;
    parameter SUMAR   = 1;
    parameter SUMAR_I = 2;
    parameter SHIFT   = 3;
    parameter DONE_ST = 4;

    reg [2:0] state;

  
      always @(negedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START: begin
                    if (init && A_i) 
                        state <= SUMAR;
                    else if (init && !A_i) 
                        state <= SUMAR_I;
                    else 
                        state <= START;
                end
                
                SUMAR: begin
                    state <= SUMAR_I;
                end
                
                SUMAR_I: begin
                    if (c) 
                        state <= DONE_ST;
                    else 
                        state <= SHIFT;
                end
                
                SHIFT: begin
                    if (A_i) 
                        state <= SUMAR;
                    else 
                        state <= SUMAR_I;
                end
                
                DONE_ST: begin
                    if (zz) 
                        state <= START;
                    else 
                        state <= DONE_ST;
                end
                
                default: state <= START;
            endcase
        end
    end

   
    always @(*) begin
        
      
        case (state)
            START:  begin rst_dp = 1'b1; 
        sum    = 1'b0;
        sumi   = 1'b0;
        done   = 1'b0;
        shft   = 1'b0;end
            SUMAR: begin  sum    = 1'b1; rst_dp = 1'b0;
        sumi   = 1'b0;
        done   = 1'b0;
        shft   = 1'b0; end
            SUMAR_I: begin sumi   = 1'b1; rst_dp = 1'b0;
        sum    = 1'b0;
        done   = 1'b0;
        shft   = 1'b0; end
            SHIFT:   begin shft   = 1'b1; rst_dp = 1'b0;
        sum    = 1'b0;
        sumi   = 1'b0;
        done   = 1'b0; end 
            DONE_ST: begin done   = 1'b1; rst_dp = 1'b0;
        sum    = 1'b0;
        sumi   = 1'b0;
        shft   = 1'b0; end
        default: begin
                rst_dp = 1'b0;
                sum    = 1'b0;
                sumi   = 1'b0;
                done   = 1'b0;
                shft   = 1'b0;
            end
        endcase
    end

`ifdef BENCH
    reg [8*10:1] state_name;
    always @(*) begin
        case(state)
            START   : state_name = "START";
            SUMAR   : state_name = "SUMAR";
            SUMAR_I : state_name = "SUMAR_I";
            SHIFT   : state_name = "SHIFT";
            DONE_ST : state_name = "DONE_ST";
        endcase
    end
`endif

endmodule