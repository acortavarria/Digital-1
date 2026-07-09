`timescale 1ns / 1ps
`define SIMULATION

module RegistroyBitIndex16_TB;

    reg clk;
    reg rst;
    reg [15:0] in;
    reg [4:0] i;
    wire in_i;
    wire [15:0] in_reg;

    // Instanciación de la UUT
    RegistroyBitIndex16 uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .i(i),
        .in_i(in_i),
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
        #0 rst = 0; in = 16'b1000_0000_0000_0101; i = 5'd0; // bit 0 = 1, bit 1 = 0, bit 2 = 1, bit 15 = 1
        @(posedge clk);
        rst = 1; // Carga el valor 'in'
        @(posedge clk);
        rst = 0;
        
        // Cambiamos el índice de bit 'i' para inspeccionar las salidas combinacionales
        #40 i = 5'd1;  // Debe dar 0
        #40 i = 5'd2;  // Debe dar 1
        #40 i = 5'd3;  // Debe dar 0
        #40 i = 5'd15; // Debe dar 1
    end

    initial begin: TEST_CASE
        $dumpfile("RegistroyBitIndex16_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
