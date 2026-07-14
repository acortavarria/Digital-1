`timescale 1ns / 1ps
`define SIMULATION

module blink_TB;

   reg clk;
   reg rst;
   blink uut( .clk(clk), .rst(rst)  );

   parameter PERIOD          = 20;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;

   initial  begin  // Process for clk
     #OFFSET;
     forever
       begin
         clk = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
         #(PERIOD*DUTY_CYCLE);
       end
   end

   initial begin // Reset the system, Start the image capture process
      rst = 0;
   end

   reg [2:0] i;
   initial begin // Reset the system, Start the image capture process
        #20 rst = 0;
        @ (posedge clk);
        @ (negedge clk);
        rst = 1;
       end

   initial begin: TEST_CASE
     $dumpfile("blink_TB.vcd");
     $dumpvars(-1, uut);
     #(10000) $finish;
   end
endmodule

