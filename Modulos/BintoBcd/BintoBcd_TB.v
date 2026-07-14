`timescale 1ns / 1ps

module tb_BinToBcd_Top;

    // Entradas
    reg clk;
    reg reset;
    reg init;
    reg [12:0] bin_in;

    // Salidas
    wire [15:0] bcd_out;
    wire done;

    // Variables internas para la validación
    integer i;
    integer errores;
    reg [15:0] bcd_esperado;
    integer th, h, t, u; // Millares, centenas, decenas, unidades

    // Instancia del módulo (Device Under Test)
    BinToBcd_Top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .bin_in(bin_in),
        .bcd_out(bcd_out),
        .done(done)
    );

    // Generador de Reloj (Periodo de 10ns -> 100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Secuencia de Estímulos
    initial begin
        // Configuración para ver formas de onda en GTKWave / ModelSim
        $dumpfile("tb_bintobcd.vcd");
        $dumpvars(0, tb_BinToBcd_Top);

        // Condiciones iniciales
        reset = 1;
        init = 0;
        bin_in = 0;
        errores = 0;

        // Esperamos un par de ciclos y soltamos el reset
        #20;
        reset = 0;
        #20;

        $display("Iniciando prueba exhaustiva de los 8192 valores...");

        // Bucle principal: Inyectar todos los valores posibles de 13 bits
        for (i = 0; i < 8192; i = i + 1) begin
            
            // 1. Calcular en simulación el valor BCD correcto
            th = i / 1000;
            h  = (i % 1000) / 100;
            t  = (i % 100) / 10;
            u  = i % 10;
            // Desplazamos cada dígito a su posición (nibble) correspondiente
            bcd_esperado = (th << 12) | (h << 8) | (t << 4) | u;

            // 2. Aplicar el valor al puerto
            bin_in = i[12:0];
            
            // 3. Disparar el handshake de inicio sincronizado al reloj
            @(posedge clk);
            init = 1;
            @(posedge clk);
            init = 0;

            // 4. Esperar a que la FSM avise que terminó (done = 1)
            wait (done == 1'b1);
            
            // 5. Evaluar si la salida de hardware coincide con la teórica
            if (bcd_out !== bcd_esperado) begin
                $display("ERROR en binario: %0d | Esperado (Hex): %04x | Obtenido (Hex): %04x", 
                          i, bcd_esperado, bcd_out);
                errores = errores + 1;
            end

            // 6. Esperar a que termine el delay de 27 ciclos de 'done' 
            // y regrese a START (done = 0) antes de enviar el siguiente valor
            wait (done == 1'b0);
            #10;
        end

        // Reporte final de la consola
        $display("--------------------------------------------------");
        if (errores == 0)
            $display("¡ÉXITO TOTAL! Los 8192 valores se convirtieron perfectamente.");
        else
            $display("FALLA: Se detectaron %0d errores en la conversión.", errores);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
