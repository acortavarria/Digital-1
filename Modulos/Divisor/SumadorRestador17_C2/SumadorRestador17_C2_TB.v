`timescale 1ns / 1ps
`define SIMULATION

module SumadorRestador_C2_TB;

    reg sum;
    reg restar;
    reg [16:0] Aext;
    reg [16:0] B;
    wire [16:0] result;

    // Instanciación de la UUT
    SumadorRestador_C2 uut (
        .sum(sum),
        .restar(restar),
        .Aext(Aext),
        .B(B),
        .result(result)
    );

    initial begin
        // Caso 1: Pasar Aext directo (sum=0, restar=0)
        #0  sum = 0; restar = 0; Aext = 17'd50; B = 17'd20;
        
        // Caso 2: Suma pura (50 + 20 = 70)
        #40 sum = 1; restar = 0;
        
        // Caso 3: Resta en Complemento a 2 (50 - 20 = 30)
        #40 sum = 0; restar = 1;
        
        // Caso 4: Resta con resultado negativo (20 - 50 = -30)
        #40 Aext = 17'd20; B = 17'd50;
        
        // Caso 5: Volver a estado pasivo
        #40 sum = 0; restar = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("SumadorRestador_C2_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
