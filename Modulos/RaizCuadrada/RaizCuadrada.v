module Raiz_Top (
    input clk,
    input reset,
    input init,
    input [15:0] A,
    output [15:0] Raiz,
    output done
);
    wire rst, shft, agg, sumi;
    wire c, zz;

    wire [16:0] Residuo;
    wire [16:0] Aextreg;
    
    
    wire [16:0] Test_Val = (Raiz<<1) + 1'b1; 
    
    wire Residuo_16 = Residuo[16];

    wire [4:0] i_w;
    wire [4:0] count_w;

    fsm_raiz ControlUnit (
        .clk(clk), .init(init), .reset(reset), .Residuo_16(Residuo_16), 
        .c(c), .zz(zz),
        .rst(rst), .shft(shft), .agg(agg), 
        .sumi(sumi), .done(done)
    );

    RegistroAext2 Reg_Acum (
        .clk(clk), .rst(rst), .shft(shft), .upd_Aext(agg),
        .in_A(A), .alu_in(Residuo), 
        .Aext(Aextreg)
    );
   
    RegistroCociente Reg_Raiz (
        .clk(clk), .rst(rst), .shft(shft), .agg(agg), 
        .C(Raiz)
    );

    SumadorRestador_C2 ALU (
        .Aext(Aextreg), .B(Test_Val), .sum(0), .restar(1'b1), .result(Residuo)
    );

    contador Contador_I (
        .clk(clk), .rst(rst), .en(sumi), .count(i_w)
    );

    comparador Comp_I (
        .in(i_w), .COMP(5'd7), .equal(c) 
    );

    contador Contador_Wait (
        .clk(clk), .rst(rst), .en(done), .count(count_w)
    );

    comparador Comp_Wait (
        .in(count_w), .COMP(5'd27), .equal(zz)
    );

endmodule