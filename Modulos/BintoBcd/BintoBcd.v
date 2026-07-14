module BinToBcd_Top (
    input clk,
    input reset,
    input init,
    input [12:0] bin,
    output [15:0] bcd,
    output done
);
    wire rst, eval, sumi;
 
    wire need_adj, c, zz;
 
    wire [28:0] shift_reg_val;
    wire [15:0] bcd_adj_val;
    wire [4:0]  i_w;
    wire [4:0]  count_w;
 
    assign bcd = shift_reg_val[28:13];
 
    wire [3:0] u       = shift_reg_val[16:13];
    wire [3:0] d       = shift_reg_val[20:17];
    wire [3:0] C = shift_reg_val[24:21];
    wire [3:0] m       = shift_reg_val[28:25];
 
    
    wire [4:0] res_sub_u, res_sub_d, res_sub_c, res_sub_m;
 
    
    wire uu = ~res_sub_u[4];
    wire dd = ~res_sub_d[4];
    wire cc = ~res_sub_c[4];
    wire mm = ~res_sub_m[4];
 
    assign need_adj = (uu | dd | cc | mm);
 
    
    wire [4:0] res_add_u, res_add_d, res_add_c, res_add_m;
 
   
    wire [3:0] u_next = uu ? res_add_u[3:0] : u;
    wire [3:0] d_next = dd ? res_add_d[3:0] : d;
    wire [3:0] c_next = cc ? res_add_c[3:0] : C;
    wire [3:0] m_next = mm ? res_add_m[3:0] : m;
 
    assign bcd_adj_val = {m_next, c_next, d_next, u_next};
 

 
    fsm_bintobcd ControlUnit (
        .clk(clk), .init(init), .reset(reset),
        .need_adj(need_adj), .c(c), .zz(zz),
        .rst(rst), .eval(eval), .sumi(sumi), .done(done)
    );
 
    Registro_Shift_BCD Reg_Datos (
        .clk(clk), .rst(rst), .sumi(sumi), .eval(eval),
        .bin(bin), .bcd_adj_in(bcd_adj_val),
        .shift_reg(shift_reg_val)
    );
 
    SumadorRestador_C2_5b Sub_U (.sum(1'b0), .restar(1'b1), .Aext({1'b0, u}),       .B(5'd5), .result(res_sub_u));
    SumadorRestador_C2_5b Sub_D (.sum(1'b0), .restar(1'b1), .Aext({1'b0, d}),       .B(5'd5), .result(res_sub_d));
    SumadorRestador_C2_5b Sub_C (.sum(1'b0), .restar(1'b1), .Aext({1'b0, C}), .B(5'd5), .result(res_sub_c));
    SumadorRestador_C2_5b Sub_M (.sum(1'b0), .restar(1'b1), .Aext({1'b0, m}),       .B(5'd5), .result(res_sub_m));
 
    SumadorRestador_C2_5b Add_U (.sum(1'b1), .restar(1'b0), .Aext({1'b0, u}),       .B(5'd3), .result(res_add_u));
    SumadorRestador_C2_5b Add_D (.sum(1'b1), .restar(1'b0), .Aext({1'b0, d}),       .B(5'd3), .result(res_add_d));
    SumadorRestador_C2_5b Add_C (.sum(1'b1), .restar(1'b0), .Aext({1'b0, C}), .B(5'd3), .result(res_add_c));
    SumadorRestador_C2_5b Add_M (.sum(1'b1), .restar(1'b0), .Aext({1'b0, m}),       .B(5'd3), .result(res_add_m));
 
    contador Contador_I (
        .clk(clk), .rst(rst), .en(sumi), .count(i_w)
    );
 
    comparador Comp_I (
        .in(i_w), .COMP(5'd12), .equal(c)
    );
 
    contador Contador_Wait (
        .clk(clk), .rst(rst), .en(done), .count(count_w)
    );
 
    comparador Comp_Wait (
        .in(count_w), .COMP(5'd27), .equal(zz)
    );
 
endmodule
 

