// ============================================================
// sqrt_tb.v  –  Testbench
// Prueba: sqrt(64)=8, sqrt(25)=5, sqrt(144)=12, sqrt(255)=15
// ============================================================
`timescale 1ns/1ps

module sqrt_tb;
    parameter N = 8;

    reg         clk, reset, init;
    reg  [N-1:0] S;
    wire [N/2-1:0] Res;
    wire           done;

    // DUT
    sqrt_top #(N) dut (
        .clk  (clk),
        .reset(reset),
        .init (init),
        .S    (S),
        .Res  (Res),
        .done (done)
    );

    // Clock 10 ns
    always #5 clk = ~clk;

    task run_test;
        input [N-1:0] val;
        input [N/2-1:0] expected;
        begin
            @(negedge clk);
            reset = 1; S = val; init = 0;
            @(negedge clk); reset = 0;
            @(negedge clk); init = 1;
            @(negedge clk); init = 0;

            // Espera done
            wait(done === 1'b1);
            @(negedge clk);

            if (Res === expected)
                $display("PASS  sqrt(%0d) = %0d", val, Res);
            else
                $display("FAIL  sqrt(%0d) = %0d  (esperado %0d)", val, Res, expected);
        end
    endtask

    initial begin
        clk = 0; reset = 1; init = 0; S = 0;
        #20;

        run_test(8'd64,  4'd8);
        run_test(8'd25,  4'd5);
        run_test(8'd36,  4'd6);
        run_test(8'd255, 4'd15);
        run_test(8'd1,   4'd1);
        run_test(8'd0,   4'd0);

        $display("Testbench finalizado.");
        $finish;
    end

    // Dump de ondas
    initial begin
        $dumpfile("sqrt_tb.vcd");
        $dumpvars(0, sqrt_tb);
    end

endmodule
