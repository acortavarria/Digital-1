module BcdToBin_Top (
    input clk,
    input reset,
    input init,
    input [15:0] bcd,
    output [12:0] bin,
    output done
);
    wire rst, eval, sumi;
    wire need_adj, c, zz;
    wire [28:0] shift_reg_val;
    wire [15:0] bcd_adj_val;
    wire [4:0]  i_w;
    wire [4:0]  count_w;
 
    assign bin = shift_reg_val[12:0];
 
    wire [3:0] u       = shift_reg_val[16:13];
    wire [3:0] d       = shift_reg_val[20:17];
    wire [3:0] c_digit = shift_reg_val[24:21];
    wire [3:0] m       = shift_reg_val[28:25];
 
    wire [4:0] res_chk_u, res_chk_d, res_chk_c, res_chk_m;
 
    wire uu = ~res_chk_u[4];
    wire dd = ~res_chk_d[4];
    wire cc = ~res_chk_c[4];
    wire mm = ~res_chk_m[4];
 
    assign need_adj = (uu | dd | cc | mm);
 
    wire [4:0] res_sub_u, res_sub_d, res_sub_c, res_sub_m;
 
    wire [3:0] u_next = uu ? res_sub_u[3:0] : u;
    wire [3:0] d_next = dd ? res_sub_d[3:0] : d;
    wire [3:0] c_next = cc ? res_sub_c[3:0] : c_digit;
    wire [3:0] m_next = mm ? res_sub_m[3:0] : m;
 
    assign bcd_adj_val = {m_next, c_next, d_next, u_next};
 
    fsm_bcdtobin ControlUnit (
        .clk(clk), .init(init), .reset(reset),
        .need_adj(need_adj), .c(c), .zz(zz),
        .rst(rst), .eval(eval), .sumi(sumi), .done(done)
    );
 
    Registro_Shift_BcdToBin Reg_Datos (
        .clk(clk), .rst(rst), .sumi(sumi), .eval(eval),
        .bcd(bcd), .bcd_adj_val(bcd_adj_val),
        .shift_reg(shift_reg_val)
    );
 
    SumadorRestador_C2_5b Chk_U (.sum(1'b0), .restar(1'b1), .Aext({1'b0, u}),       .B(5'd8), .result(res_chk_u));
    SumadorRestador_C2_5b Chk_D (.sum(1'b0), .restar(1'b1), .Aext({1'b0, d}),       .B(5'd8), .result(res_chk_d));
    SumadorRestador_C2_5b Chk_C (.sum(1'b0), .restar(1'b1), .Aext({1'b0, c_digit}), .B(5'd8), .result(res_chk_c));
    SumadorRestador_C2_5b Chk_M (.sum(1'b0), .restar(1'b1), .Aext({1'b0, m}),       .B(5'd8), .result(res_chk_m));
 
    SumadorRestador_C2_5b Sub_U (.sum(1'b0), .restar(1'b1), .Aext({1'b0, u}),       .B(5'd3), .result(res_sub_u));
    SumadorRestador_C2_5b Sub_D (.sum(1'b0), .restar(1'b1), .Aext({1'b0, d}),       .B(5'd3), .result(res_sub_d));
    SumadorRestador_C2_5b Sub_C (.sum(1'b0), .restar(1'b1), .Aext({1'b0, c_digit}), .B(5'd3), .result(res_sub_c));
    SumadorRestador_C2_5b Sub_M (.sum(1'b0), .restar(1'b1), .Aext({1'b0, m}),       .B(5'd3), .result(res_sub_m));
 
    contador Contador_I (
        .clk(clk), .rst(rst), .en(sumi), .count(i_w)
    );
 
    comparador Comp_I (
        .in(i_w), .COMP(5'd13), .equal(c)
    );
 
    contador Contador_Wait (
        .clk(clk), .rst(rst), .en(done), .count(count_w)
    );
 
    comparador Comp_Wait (
        .in(count_w), .COMP(5'd27), .equal(zz)
    );
 
endmodule

