module Divisor_Top (
    input clk,
    input reset,
    input init,
    input [15:0] A,
    input [15:0] B,
    output [15:0] Cociente,
    output done
);
    wire rst, shft, sum, restar, agg, sumi;
    wire c, zz;

    wire [16:0] Aextreg;
    wire [15:0] Areg;
    wire [16:0] Breg; 
    wire [16:0] Aext;
    wire [4:0] i_w;
    wire [4:0] count_w; 

    // LÓGICA LOOK-AHEAD: Si estamos en SHIFT, anticipa el signo mirando el bit 15.
    // De lo contrario, lee el signo combinacional de la ALU de forma directa.
    wire Aext_16 = (shft) ? Aextreg[15] : Aext[16]; 
    
    wire upd_Aext = sum | restar;

    fsm_divisor ControlUnit (
        .clk(clk), .init(init), .Aext_16(Aext_16), .c(c), .zz(zz), .reset(reset),
        .rst(rst), .shft(shft), .sum(sum), .restar(restar), .agg(agg), .sumi(sumi), .done(done)
    );

    RegistroAext Reg_Aext_A (
        .clk(clk), .rst(rst), .shft(shft), .upd_Aext(upd_Aext),
        .in_A(A), .alu_in(Aext), .Aext(Aextreg), .A(Areg)
    );
   
    RegistroyShifter Reg_B (
        .clk(clk), .rst(rst), .shft(1'b0), .in(B), .in_reg(Breg)
    );

    RegistroCociente Reg_C (
        .clk(clk), .rst(rst), .shft(shft), .agg(agg), .C(Cociente)
    );

    SumadorRestador_C2 ALU (
        .Aext(Aextreg), .B(Breg), .sum(sum), .restar(restar), .result(Aext)
    );

    contador Contador_I (
        .clk(clk), .rst(rst), .en(sumi), .count(i_w)
    );

    comparador Comp_I (
        .in(i_w), .COMP(5'd16), .equal(c)
    );

    contador Contador_Wait (
        .clk(clk), .rst(rst), .en(done), .count(count_w)
    );

    comparador Comp_Wait (
        .in(count_w), .COMP(5'd28), .equal(zz)
    );

endmodule