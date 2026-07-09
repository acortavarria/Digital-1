`timescale 1ns / 1ps
`define SIMULATION

module RegistroAext_TB;

    reg clk;
    reg rst;
    reg shft;
    reg upd_Aext;
    reg [15:0] in_A;
    reg [16:0] alu_in;
    
    wire [16:0] Aext;
    wire [15:0] A;

    // Instanciación de la UUT
    RegistroAext uut (
        .clk(clk),
        .rst(rst),
        .shft(shft),
        .upd_Aext(upd_Aext),
        .in_A(in_A),
        .alu_in(alu_in),
        .Aext(Aext),
        .A(A)
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
        #0 rst = 0; shft = 0; upd_Aext = 0; in_A = 16'h5555; alu_in = 17'h0AAAA;
        @(posedge clk);
        rst = 1;               // Al resetear, Aext se limpia e in_A pasa a A
        @(posedge clk);
        rst = 0;
        
        // Probar el desplazamiento conjunto {Aext, A} << 1
        @(posedge clk);
        shft = 1;
        @(posedge clk);
        shft = 0;
        
        // Probar la actualización del acumulador desde la ALU (upd_Aext)
        @(posedge clk);
        upd_Aext = 1;
        @(posedge clk);
        upd_Aext = 0;
        #80;
    end

    initial begin: TEST_CASE
        $dumpfile("RegistroAext_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
