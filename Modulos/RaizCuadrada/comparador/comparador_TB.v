`timescale 1ns / 1ps
`define SIMULATION

module comparador_TB;

    reg [4:0] in;
    reg [4:0] COMP;
    wire equal;

    // Instanciación de la Unidad Bajo Prueba (UUT)
    comparador uut (
        .in(in),
        .COMP(COMP),
        .equal(equal)
    );

    initial begin
        // Estímulos de prueba espaciados por 40ns
        #0  in = 5'd10; COMP = 5'd15; // Diferentes
        #40 in = 5'd15; COMP = 5'd15; // Iguales -> equal = 1
        #40 in = 5'd20; COMP = 5'd15; // Diferentes
        #40 in = 5'd0;  COMP = 5'd0;  // Iguales -> equal = 1
        #40 in = 5'd7;  COMP = 5'd14; // Diferentes
    end

    initial begin: TEST_CASE
        $dumpfile("comparador_TB.vcd");
        $dumpvars(-1, uut);
        #(100000) $finish;
    end

endmodule
