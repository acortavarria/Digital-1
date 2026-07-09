`timescale 1ns / 1ps
`define SIMULATION

module RegistroyShifter_TB;

    reg clk;
    reg rst;
    reg shft;
    reg [15:0] in;
    wire [31:0] in_reg;

    // Instanciación de la UUT
    RegistroyShifter uut (
        .clk(clk),
        .rst(rst),
        .shft(shft),
        .in(in),
        .in_reg(in_reg)
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
        #0 rst = 0; shft = 0; in = 16'hAAAA; // Patrón alternado (1010101010101010)
        @(posedge clk);
        rst = 1; // Carga el valor inicial de 'in' en 'in_reg'
        @(posedge clk);
        rst = 0;
        
        // Aplicar desplazamientos sucesivos a la izquierda
        repeat (5) begin
            @(posedge clk);
            shft = 1;
        end
        @(posedge clk);
        shft = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("RegistroyShifter_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
