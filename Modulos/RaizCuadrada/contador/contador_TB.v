`timescale 1ns / 1ps
`define SIMULATION

module contador_TB;

    reg clk;
    reg rst;
    reg en;
    wire [4:0] count;

    // Instanciación de la UUT
    contador uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .count(count)
    );

    // Parámetros del Reloj
    parameter PERIOD          = 40;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET          = 0;

    initial begin // Generador de reloj
        #OFFSET;
        forever begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    initial begin
        #0 rst = 0; en = 0;
        @(posedge clk);
        rst = 1;              // Activar reset
        @(posedge clk);
        rst = 0;              // Liberar reset
        @(posedge clk);
        en = 1;               // Habilitar conteo
        #400                  // Dejarlo contar 10 ciclos
        @(posedge clk);
        en = 0;               // Pausar conteo
        #120;
        @(posedge clk);
        rst = 1;              // Probar reset en funcionamiento
        @(posedge clk);
        rst = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("contador_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule