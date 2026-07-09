`timescale 1ns / 1ps
`define SIMULATION

module multiplicador_top_TB;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] A;
    reg [15:0] B;
    
    wire [31:0] result;
    wire done;

    // Instanciación del módulo TOP
    multiplicador_top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .B(B),
        .result(result),
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
        // Inicialización de estímulos
        #0 reset = 0; init = 0; A = 16'd0; B = 16'd0;
        
        // Reset inicial del sistema
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // Configurar operandos: 7 x 9 = 63
        @(posedge clk);
        A = 16'd7; 
        B = 16'd9;
        init = 1; // Pulso de inicio
        
        @(posedge clk);
        init = 0; 
        
        
        @(posedge done);
        
        
        #2000;
        
        // Fin de la simulación controlada
        $display("Simulacion completa. Resultado final de %d x %d = %d", A, B, result);
    end

    initial begin: TEST_CASE
        $dumpfile("Multiplicador_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish; // Límite de seguridad
    end

endmodule
