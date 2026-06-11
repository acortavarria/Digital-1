// ============================================================
// sqrt_top.v  –  Top-level: integración Datapath + Control
// Calcula raíz cuadrada entera de S (N bits → N/2 bits)
// ============================================================
module sqrt_top #(parameter N = 8)(
    input  wire           clk,
    input  wire           reset,
    input  wire           init,
    input  wire [N-1:0]   S,
    output wire [N/2-1:0] Res,
    output wire           done
);
    wire        LD, SUBR, SH_REM, SH_RES, DECC, SH_S;
    wire        replacing_bit;
    wire        v, z;

    wire [N-1:0]     s_out;
    wire [N/2-1:0]   res_out;
    wire [N/2+1:0]   rem_out;
    wire [N/2+1:0]   diff;

    s_reg #(N) u_s_reg (
        .clk   (clk), .reset(reset),
        .LD    (LD),  .SH_S (SH_S),
        .s_in  (S),   .s_out(s_out)
    );

    res_reg #(N) u_res_reg (
        .clk          (clk), .reset(reset | LD),
        .SH_RES       (SH_RES),
        .replacing_bit(replacing_bit),
        .res_out      (res_out)
    );

    remainder_reg #(N) u_rem_reg (
        .clk       (clk), .reset(reset | LD),
        .LD_SUB    (SUBR),
        .SH_REM    (SH_REM),
        .sub_result(diff),
        .s_msb     (s_out[N-1:N-2]),
        .rem_out   (rem_out)
    );

    restador #(N) u_restador (
        .remainder(rem_out), .res(res_out), .diff(diff)
    );

    comparador_rem #(N) u_comp_rem (
        .remainder(rem_out), .res(res_out), .v(v)
    );

    contador #(N) u_contador (
        .clk(clk), .reset(reset), .LD_CNT(LD), .DECC(DECC), .z(z)
    );

    control_fsm u_fsm (
        .clk(clk), .reset(reset), .init(init),
        .v(v), .z(z),
        .LD(LD), .SUBR(SUBR), .SH_REM(SH_REM), .SH_RES(SH_RES),
        .DECC(DECC), .SH_S(SH_S),
        .replacing_bit(replacing_bit), .done(done)
    );

    assign Res = res_out;
endmodule
