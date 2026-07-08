module multiplicador_top (
    input clk,
    input reset,
    input init,
    input [15:0] A,
    input [15:0] B,
    output [31:0] result,
    output done
);

   
    wire rst, sum, sumi, shft;
    
    
    wire A_i, c, zz;

    
    wire [4:0] w_i;
    wire [4:0] w_count;
    wire [31:0] Breg_shft;

   
    fsm_multiplicador control_unit (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A_i(A_i),
        .c(c),
        .zz(zz),
        .rst(rst),
        .sum(sum),
        .sumi(sumi),
        .done(done),     
        .shft(shft)
    );

    
    RegistroyBitIndex16 reg_A (
        .clk(clk),
        .rst(rst),
        .in(A),
        .i(w_i),
        .in_i(A_i),
        .in_reg()        
    );


    RegistroyShifter reg_B (
        .clk(clk),
        .rst(rst),
        .shft(shft),
        .in(B),
        .in_reg(Breg_shft)
    );

    
    sumador32 acumulador (
        .clk(clk),
        .rst(rst),
        .sum(sum),
        .A(result),             
        .B(Breg_shft),
        .result(result)         
    );


    contador cont_i (
        .clk(clk),
        .rst(rst),
        .en(sumi),
        .count(w_i)
    );

   
    comparador comp_i (
        .in(w_i),
        .COMP(5'd15),
        .equal(c)
    );

   
    contador cont_espera (
        .clk(clk),
        .rst(rst),
        .en(done),              
        .count(w_count)
    );

    
    comparador comp_espera (
        .in(w_count),
        .COMP(5'd27),
        .equal(zz)
    );

endmodule