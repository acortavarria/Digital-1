`timescale 1ns / 1ps
`define SIMULATION

module fsm_divisor_TB;

    reg clk;
    reg init;
    reg reset;
    reg Aext_16;
    reg c;
    reg zz;

    wire rst, shft, sum, restar, agg, sumi, done;

    // Instanciación de la UUT
    fsm_divisor uut (
        .clk(clk), .init(init), .reset(reset), .Aext_16(Aext_16), .c(c), .zz(zz),
        .rst(rst), .shft(shft), .sum(sum), .restar(restar), .agg(agg), .sumi(sumi), .done(done)
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
        #0 init = 0; reset = 0; Aext_16 = 0; c = 0; zz = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Iniciar la FSM
        @(posedge clk);
        init = 1;
        
        // Entra a SHIFT. Evaluamos con bit de signo Aext_16 = 0 (Va a RESTAR)
        @(posedge clk);
        init = 0; Aext_16 = 0;
        
        // En estado RESTAR, si el resultado fue positivo (Aext_16 = 0), va a AGREGARC
        @(posedge clk);
        Aext_16 = 0;
        
        // De AGREGARC pasa directo a SUMAR_I. Definimos que no ha terminado el conteo (c = 0)
        @(posedge clk);
        c = 0;
        
        // Regresa a SHIFT. Ahora simulamos un caso donde Aext_16 = 1 (Va a SUMAR)
        @(posedge clk);
        Aext_16 = 1;
        
        // En estado SUMAR, si vuelve a ser negativo (Aext_16 = 1), salta a SUMAR_I sin agregar cociente
        @(posedge clk);
        Aext_16 = 1;
        
        // En SUMAR_I, simulamos que ya terminó las iteraciones (c = 1)
        @(posedge clk);
        c = 1; Aext_16 = 0; // Aext_16 = 0 para ir directo a DONE sin pasar por SUMAR2
        
        // En DONE, esperamos a que el temporizador de espera termine (zz = 1)
        #120;
        @(posedge clk);
        zz = 1;
        @(posedge clk);
        zz = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("fsm_divisor_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
