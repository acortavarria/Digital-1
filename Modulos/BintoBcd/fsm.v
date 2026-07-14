module fsm_bintobcd (
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
    parameter ESPERAR     = 1;
    parameter CHECKYSUM   = 2;
    parameter SUMARYSHIFT = 3;
    parameter DONE        = 4;
    reg [2:0] state;
 
    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START:       state <= init     ? ESPERAR   : START;
                ESPERAR:     state <= need_adj  ? CHECKYSUM : SUMARYSHIFT;
                CHECKYSUM:   state <= SUMARYSHIFT;
                SUMARYSHIFT: state <= c         ? DONE      : ESPERAR;
                DONE:        state <= zz        ? START     : DONE;
                default:     state <= START;
            endcase
        end
    end
 
    always @(*) begin
        rst = 1'b0; eval = 1'b0; sumi = 1'b0; done = 1'b0;
        case (state)
            START:  begin     rst  = 1'b1; eval = 1'b0; sumi = 1'b0; done = 1'b0; end
            ESPERAR:   begin  rst = 1'b0; eval = 1'b0; sumi = 1'b0; done = 1'b0; end
            CHECKYSUM:   begin rst = 1'b0; eval = 1'b1; sumi = 1'b0; done = 1'b0; end
            SUMARYSHIFT: begin sumi = 1'b1; rst = 1'b0; eval = 1'b0; done = 1'b0; end
            DONE:    begin    done = 1'b1; rst = 1'b0; eval = 1'b0; sumi = 1'b0;  end
            default: begin
                rst = 1'b0; eval = 1'b0; sumi = 1'b0; done = 1'b0;
            end
        endcase
    end
 
`ifdef BENCH
    reg [8*11:1] state_name;
    always @(*) begin
        case(state)
            START       : state_name = "START";
            ESPERAR     : state_name = "ESPERAR";
            CHECKYSUM   : state_name = "CHECKYSUM";
            SUMARYSHIFT : state_name = "SUMARYSHIFT";
            DONE        : state_name = "DONE";
            default     : state_name = "START";
        endcase
    end
`endif
 
endmodule
 
