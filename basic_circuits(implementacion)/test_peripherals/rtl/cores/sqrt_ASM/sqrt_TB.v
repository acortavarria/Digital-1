`timescale 1ns / 1ps
`define SIMULATION
module sqrt_TB;
   reg  clk;
   reg  rst;
   reg  start;
   reg  [15:0]A;
   wire [15:0] result;
   wire done;
   sqrt uut (.clk(clk) , .rst(rst) , .init(start) , .A(A) , .result(result) , .done(done));

   parameter PERIOD          = 20;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;

   initial begin  // Initialize Inputs
      clk = 0; rst = 0; start = 0; A = 16'h0441;
   end
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
        @ (negedge clk);
        rst = 1;
        @ (negedge clk);
        rst = 0;
        @ (posedge clk);
        start = 0;
        @ (posedge clk);
        start = 1;
       for(i=0; i<2; i=i+1) begin
         @ (posedge clk);
       end
          start = 0;
       for(i=0; i<17; i=i+1) begin
         @ (posedge clk);
       end
   end	 
   initial begin: TEST_CASE
     $dumpfile("sqrt_TB.vcd");
     $dumpvars(-1, uut);
     #((PERIOD*DUTY_CYCLE)*120) $finish;
   end
endmodule

