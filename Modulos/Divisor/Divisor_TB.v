`timescale 1ns / 1ps
`define SIMULATION

module Divisor_Top_TB;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] A;
    reg [15:0] B;
    
    wire [15:0] Cociente;
    wire done;

    // Instanciación del módulo TOP del divisor
    Divisor_Top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .B(B),
        .Cociente(Cociente),
        .done(done)
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
        // Inicialización
        #0 reset = 0; init = 0; A = 16'd0; B = 16'd0;
        
        // Reset global del sistema
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Configurar la operación: 100 / 5
        @(posedge clk);
        A = 16'd100;
        B = 16'd5;
        init = 1;               // Pulso de inicio de la máquina de estados
        
        @(posedge clk);
        init = 0;               // Apagar init para evitar bucles de reinicio
        
        // Esperar la bandera de finalización de cómputo de la división
        @(posedge done);
        
        // Dar un margen de tiempo para observar el ciclo de espera final (zz) en GTKWave
        #2000;
        
        $display("Simulacion del Divisor completada.");
        $display("Operacion: %d / %d = %d", A, B, Cociente);
    end

    initial begin: TEST_CASE
        $dumpfile("Divisor_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish; // Fin seguro de simulación
    end

endmodule
