`timescale 1ns / 1ps
`define SIMULATION

module fsm_multiplicador_TB;

    reg clk;
    reg reset;
    reg init;
    reg A_i;
    reg c;
    reg zz;
    
    wire rst, sum, sumi, done, shft;

    // Instanciación de la UUT
    fsm_multiplicador uut (
        .clk(clk), .reset(reset), .init(init), .A_i(A_i), .c(c), .zz(zz),
        .rst(rst), .sum(sum), .sumi(sumi), .done(done), .shft(shft)
    );

    // Parámetros del Reloj
    parameter PERIOD          = 40;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET          = 0;

    initial begin
        #OFFSET;
        forever begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    initial begin
        #0 reset = 0; init = 0; A_i = 0; c = 0; zz = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Ciclo 1: Iniciar multiplicación con bit A_i = 1 (Va a estado SUMAR)
        @(posedge clk);
        init = 1; A_i = 1;
        @(posedge clk);
        init = 0;
       
        @(posedge clk); 
        c = 0;
        
       
        @(posedge clk);
        A_i = 0;
        
        
        @(posedge clk);
        c = 1;
        
        
        #120;
        @(posedge clk);
        zz = 1; // Termina la espera, regresa a START
        @(posedge clk);
        zz = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("fsm_multiplicador_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
