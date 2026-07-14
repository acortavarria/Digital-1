`timescale 1ns / 1ps
`define SIMULATION

module comp_TB;

   reg [15:0] B;

   comp uut(.B(B));

   initial begin  // Initialize Inputs
    B = 16'h007F;
   end

   initial begin //
        #10 B = 16'h007F;
        #10 B = 16'h00AA;
        #10 B = 16'h0000;
        #10 B = 16'h00FF;
   end

   initial begin: TEST_CASE
     $dumpfile("comp_TB.vcd");
     $dumpvars(-1, uut);
     #(120) $finish;
   end
endmodule

