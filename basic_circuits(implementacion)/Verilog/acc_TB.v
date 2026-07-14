`timescale 1ns / 1ps
`define SIMULATION

module acc_TB;

   reg clk;
   reg add;
   reg rst;
   reg [4:0]A;

   acc uut( .clk(clk) , .A(A) , .add(add) , .rst(rst)  );

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
      rst = 0; add = 0; A = 5'h00;
   end

   reg [2:0] i;
   initial begin // Reset the system, Start the image capture process
        #20 rst = 1;
        A = 1;
        @ (posedge clk);
        @ (negedge clk);
        rst = 0;
        @ (posedge clk);
        @ (negedge clk);
        add = 1;
       for(i=0; i<10; i=i+1) begin
         @ (posedge clk);
       end
   end


   initial begin: TEST_CASE
     $dumpfile("acc_TB.vcd");
     $dumpvars(-1, uut);
     #(1000) $finish;
   end
endmodule

