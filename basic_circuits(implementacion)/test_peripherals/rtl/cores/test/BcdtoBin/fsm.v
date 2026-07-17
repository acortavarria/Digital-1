module fsm_bcdtobin (
    input clk,
    input init,
    input reset,
    input need_adj,
    input c,
    input zz,
    output reg rst,
    output reg eval,
    output reg sumi,
    output reg done
);
    parameter START       = 0;
    parameter SUMARYSHIFT = 1;
    parameter CHECK       = 2;
    parameter CHECKYRESTA = 3;
    parameter DONE        = 4;
    reg [2:0] state;
 
    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START:       state <= init ? SUMARYSHIFT : START;
                SUMARYSHIFT: state <= CHECK;
                CHECK:       state <= need_adj ? CHECKYRESTA : (c ? DONE : SUMARYSHIFT);
                CHECKYRESTA: state <= c ? DONE : SUMARYSHIFT;
                DONE:        state <= zz ? START : DONE;
                default:     state <= START;
            endcase
        end
    end
 
    always @(*) begin
        rst = 1'b0; eval = 1'b0; sumi = 1'b0; done = 1'b0;
        case (state)
            START:       rst  = 1'b1;
            SUMARYSHIFT: sumi = 1'b1;
            CHECK:       ;
            CHECKYRESTA: eval = 1'b1;
            DONE:        done = 1'b1;
        endcase
    end
endmodule

