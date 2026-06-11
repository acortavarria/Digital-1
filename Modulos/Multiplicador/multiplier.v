

module multiplier #(parameter N = 8)(
    input  wire         clk, rst, start,
    input  wire [N-1:0] A_in, B_in,
    output wire [N-1:0] P_out,
    output wire         done
);
    wire LD, SHFT, ADD;
    wire B_LSB, B_ZERO;
    wire [N-1:0] A_shifted, B_current;

    assign B_ZERO = (B_current == {N{1'b0}});

    shift_register #(.N(N),.DIR(1)) A_REG (.clk(clk),.rst(rst),.LD(LD),.SHFT(SHFT),.D(A_in),.Q(A_shifted),.LSB());
    shift_register #(.N(N),.DIR(0)) B_REG (.clk(clk),.rst(rst),.LD(LD),.SHFT(SHFT),.D(B_in),.Q(B_current),.LSB(B_LSB));
    accumulator    #(.N(N))         R_ACC (.clk(clk),.rst(rst),.LD(LD),.ADD(ADD),.A_in(A_shifted),.Q(P_out));
    control_unit                    FSM   (.clk(clk),.rst(rst),.start(start),.B_LSB(B_LSB),.B_ZERO(B_ZERO),.LD(LD),.SHFT(SHFT),.ADD(ADD),.DONE(done));
endmodule
