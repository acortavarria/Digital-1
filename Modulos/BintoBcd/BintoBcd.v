module BinToBcd_Top (
    input clk,
    input reset,
    input init,
    input [12:0] bin_in,
    output [15:0] bcd_out,
    output done
);
    wire rst, eval_bcd, sumi;
    wire need_adj, c, zz;
    wire [28:0] shift_reg_val;
    wire [15:0] bcd_adj_val;
    wire [4:0] i_w;
    wire [4:0] count_w;
    assign bcd_out = shift_reg_val[28:13];
    fsm_bintobcd ControlUnit (
        .clk(clk), .init(init), .reset(reset), 
        .need_adj(need_adj), .c(c), .zz(zz),
        .rst(rst), .eval_bcd(eval_bcd), .sumi(sumi), .done(done)
    );
    Registro_Shift_BCD Reg_Datos (
        .clk(clk), .rst(rst), .shft(sumi), .load_bcd(eval_bcd),
        .bin_in(bin_in), .bcd_adj_in(bcd_adj_val),
        .shift_reg(shift_reg_val)
    );
    Ajuste_BCD Box_Ajuste (
        .bcd_in(shift_reg_val[28:13]),
        .bcd_out(bcd_adj_val),
        .need_adj(need_adj)
    );
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

