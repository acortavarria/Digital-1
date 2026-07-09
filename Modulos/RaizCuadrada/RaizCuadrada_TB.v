`timescale 1ns / 1ps
`define SIMULATION

module Raiz_Top_TB;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] A;
    
    wire [15:0] Raiz;
    wire done;

    // Instanciación del módulo Top
    Raiz_Top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .Raiz(Raiz),
        .done(done)
    );

    // Parámetros del Reloj
    parameter PERIOD          = 40;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET          = 0;

    initial begin // Generación del reloj
        #OFFSET;
        forever begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    initial begin
        // Inicialización de señales
        #0 reset = 0; init = 0; A = 16'd0;
        
        // Reset del sistema
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Iniciar el cálculo de la raíz cuadrada de 144
        @(posedge clk);
        A = 16'd144;
        init = 1;
        
        @(posedge clk);
        init = 0; // Apagar pulso de inicio
        
        // Esperar a que la señal done se ponga en alto
        @(posedge done);
        
        // Dar algo de tiempo para observar el estado DONE y el contador de espera
        #2000;
        
        $display("Simulacion de Raiz Cuadrada completada.");
        $display("Raiz de %d = %d", A, Raiz);
        
        // Opcional: Probar otro número, por ejemplo 49 (Raíz = 7)
        A = 16'd49;
        init = 1;
        @(posedge clk);
        init = 0;
        
        @(posedge done);
        #2000;
        $display("Raiz de %d = %d", A, Raiz);
        
    end

    initial begin: TEST_CASE
        $dumpfile("Raiz_Top_TB.vcd");
        $dumpvars(-1, uut);
        #(200000) $finish; // Límite un poco más amplio por si haces 2 pruebas
    end

endmodule
