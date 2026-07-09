`timescale 1ns / 1ps
`define SIMULATION

module fsm_raiz_TB;

    reg clk;
    reg init;
    reg reset;
    reg Residuo_16;
    reg c;
    reg zz;

    wire rst;
    wire shft;
    wire agg;
    wire sumi;
    wire done;

    // Instanciación de la UUT
    fsm_raiz uut (
        .clk(clk),
        .init(init),
        .reset(reset),
        .Residuo_16(Residuo_16),
        .c(c),
        .zz(zz),
        .rst(rst),
        .shft(shft),
        .agg(agg),
        .sumi(sumi),
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
        // Inicialización
        #0 init = 0; reset = 0; Residuo_16 = 0; c = 0; zz = 0;
        
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Arrancar FSM
        @(posedge clk);
        init = 1;
        
        // Transición START -> SHIFT -> ESPERAR
        @(posedge clk);
        init = 0;
        
        // En estado ESPERAR, si Residuo_16 = 0, debe ir a AGGyLD
        @(posedge clk);
        Residuo_16 = 0;
        
        // Pasa a AGGyLD, luego automáticamente a SUMAR_I.
        // En SUMAR_I, si c = 0, debe regresar a SHIFT
        @(posedge clk);
        c = 0;
        
        // Regresa a SHIFT, luego a ESPERAR. 
        // Ahora simulamos Residuo_16 = 1 (debe saltarse AGGyLD e ir a SUMAR_I)
        #80; // Esperar a que llegue de nuevo a ESPERAR
        @(posedge clk);
        Residuo_16 = 1;
        
        // En SUMAR_I, simulamos que terminó la cuenta (c = 1), debe ir a DONE
        @(posedge clk);
        c = 1;
        
        // En estado DONE, esperamos la señal zz para regresar a START
        #120;
        @(posedge clk);
        zz = 1;
        @(posedge clk);
        zz = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("fsm_raiz_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
