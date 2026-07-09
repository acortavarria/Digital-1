`timescale 1ns / 1ps
`define SIMULATION

module RegistroCociente_TB;

    reg clk;
    reg rst;
    reg shft;
    reg agg;
    wire [15:0] C;

    // Instanciación de la UUT
    RegistroCociente uut (
        .clk(clk),
        .rst(rst),
        .shft(shft),
        .agg(agg),
        .C(C)
    );

    // Parámetros del Reloj
    parameter PERIOD          = 40;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET          = 0;

    initial begin // Proceso de reloj
        #OFFSET;
        forever begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    initial begin
        #0 rst = 0; shft = 0; agg = 0;
        @(posedge clk);
        rst = 1;                // Reset del registro
        @(posedge clk);
        rst = 0;
        
        // Desplazar e ingresar un 1 (típico del algoritmo de división)
        @(posedge clk);
        shft = 1; agg = 1;      // C se vuelve 1
        
        // Desplazar sin agregar (entra un cero por derecha)
        @(posedge clk);
        shft = 1; agg = 0;      // C se mueve de 1 a 2 (2'b10)
        
        // Mantener quieto pero forzar el bit menos significativo a 1
        @(posedge clk);
        shft = 0; agg = 1;      // C se vuelve 3 (2'b11)
        
        // Apagar controles
        @(posedge clk);
        agg = 0;
        #80;
    end

    initial begin: TEST_CASE
        $dumpfile("RegistroCociente_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
