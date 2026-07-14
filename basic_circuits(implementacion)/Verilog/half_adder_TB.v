`timescale 1ns / 1ps
`define SIMULATION

module half_adder_TB;
   reg a;
   reg b;
   reg cin;

   half_adder uut(.a(a), .b(b), .cin(cin));

   initial begin  // Initialize Inputs
    a = 0; b = 0; cin = 0;
   end

   initial begin
        #10 a = 0; b = 0; cin = 0;
        #10 a = 0; b = 1; cin = 0;
        #10 a = 1; b = 0; cin = 0;
        #10 a = 1; b = 1; cin = 0;
        #10 a = 0; b = 0; cin = 1;
        #10 a = 0; b = 1; cin = 1;
        #10 a = 1; b = 0; cin = 1;
        #10 a = 1; b = 1; cin = 1;
   end

   initial begin: TEST_CASE
     $dumpfile("half_adder_TB.vcd");
     $dumpvars(-1, uut);
     #(120) $finish;
   end
endmodule

