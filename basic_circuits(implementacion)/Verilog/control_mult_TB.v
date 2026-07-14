`timescale 1ns / 1ps
`define SIMULATION

module control_mult_TB;

 reg clk;
 reg rst;
 reg lsb_B;
 reg init;
 reg z;
 control_mult2 uut( .clk(clk), .rst(rst), .lsb_B(lsb_B), .init(init), .z(z) );

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
      rst = 0; init = 0; lsb_B = 0; z = 0;
   end


   reg [2:0] i;
   initial begin // Reset the system, Start the image capture process
        #20 rst = 1;
        @ (posedge clk);
        @ (negedge clk);
        rst = 0;
        init = 1;
        @ (posedge clk);
        @ (negedge clk);
        @ (posedge clk);
        @ (negedge clk);
        @ (posedge clk);
        @ (negedge clk);
        lsb_B = 1;
        @ (posedge clk);
        @ (negedge clk);
        lsb_B = 0;
        @ (negedge clk);
        @ (posedge clk);

        lsb_B = 1;
        @ (negedge clk);
        @ (posedge clk);
        @ (negedge clk);
        @ (posedge clk);
        lsb_B = 0;
        @ (posedge clk);
        @ (negedge clk);
        z = 1;
        @ (negedge clk);
        @ (posedge clk);
        @ (posedge clk);
        z = 0;                

       end

   initial begin: TEST_CASE
     $dumpfile("control_mult_TB.vcd");
     $dumpvars(-1, uut);
     #(1000) $finish;
   end
endmodule