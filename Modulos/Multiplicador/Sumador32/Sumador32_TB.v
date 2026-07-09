`timescale 1ns / 1ps
`define SIMULATION

module sumador32_TB;

    reg clk;
    reg rst;
    reg sum;
    reg [31:0] A;
    reg [31:0] B;
    wire [32:0] result;

    // Instanciación de la UUT
    sumador32 uut (
        .clk(clk),
        .rst(rst),
        .sum(sum),
        .A(A),
        .B(B),
        .result(result)
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
        #0 rst = 0; sum = 0; A = 32'd0; B = 32'd0;
        @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        
        // Suma 1
        @(posedge clk);
        A = 32'd1500; B = 32'd3500; sum = 1;
        @(posedge clk);
        sum = 0; // Desactivar señal de control
        
        // Cambiar valores sin activar la señal 'sum' (el registro no debe cambiar)
        @(posedge clk);
        A = 32'd5000; B = 32'd5000; 
        #80;
        
        // Suma 2 (Debe actualizarse)
        @(posedge clk);
        sum = 1;
        @(posedge clk);
        sum = 0;
    end

    initial begin: TEST_CASE
        $dumpfile("sumador32_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
