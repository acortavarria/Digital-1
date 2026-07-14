module fsm_bintobcd (
    input clk,
    input init,
    input reset,
    input need_adj,
    input c,
    input zz,
    output reg rst,
    output reg eval_bcd,
    output reg sumi,
    output reg done
);
    parameter START       = 0;
    parameter CHECK       = 1;
    parameter CHECKYSUM   = 2;
    parameter SHIFT       = 3;
    parameter DONE_ST     = 4;
    reg [2:0] state;
    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START: begin
                    state <= (init) ? CHECK : START;
                end
                CHECK: begin
                    state <= (need_adj) ? CHECKYSUM : SHIFT;
                end
                CHECKYSUM: begin
                    state <= SHIFT;
                end
                SHIFT: begin
                    state <= (c) ? DONE_ST : CHECK;
                end
                DONE_ST: begin
                    state <= (zz) ? START : DONE_ST;
                end
                default: state <= START;
            endcase
        end
    end
    always @(*) begin
        case (state)
            START: begin
                rst = 1'b1; eval_bcd = 1'b0; sumi = 1'b0; done = 1'b0;
            end
            CHECK: begin
                rst = 1'b0; eval_bcd = 1'b0; sumi = 1'b0; done = 1'b0;
            end
            CHECKYSUM: begin
                rst = 1'b0; eval_bcd = 1'b1; sumi = 1'b0; done = 1'b0;
            end
            SHIFT: begin
                rst = 1'b0; eval_bcd = 1'b0; sumi = 1'b1; done = 1'b0;
            end
            DONE_ST: begin
                rst = 1'b0; eval_bcd = 1'b0; sumi = 1'b0; done = 1'b1;
            end
            default: begin
                rst = 1'b0; eval_bcd = 1'b0; sumi = 1'b0; done = 1'b0;
            end
        endcase
    end
endmodule

