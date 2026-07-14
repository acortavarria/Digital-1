`timescale 1ns / 1ps
`define SIMULATION
module dpram_TB;
	parameter adr_width = 13;
	parameter dat_width = 16;
   reg  clk;
   reg  en_a;
   reg  en_b;
   reg  we_a;
   reg  re_b;
   reg  [adr_width-1:0] adr_a;
   reg  [adr_width-1:0] adr_b;
   reg  [dat_width-1:0] dat_a;
//   wire [dat_width-1:0] dat_b;

   dpram uut (
      .clk_a(clk),
      .en_a(en_a),
      .adr_a(adr_a),
      .dat_a(dat_a),
      .we_a(we_a),
      .clk_b(clk),
      .en_b(en_b),
      .re_b(re_b),
      .adr_b(adr_b),
      .dat_b(dat_b)
   );

   parameter PERIOD = 20;
   initial begin  // Initialize Inputs
      clk = 0; en_a = 1; en_b = 1; we_a = 0; re_b = 0;
   end
   // clk generation
   initial         clk <= 0;
   always #(PERIOD/2) clk <= ~clk;

   integer count;
   initial begin // Reset the system, Start the image capture process
        // Write
        for(count = 0; count < 20; count ++) begin
            we_a = 1;
            @ (negedge clk);
            adr_a =  count;
            dat_a =  count;
            @ (negedge clk);
            we_a = 0;
            @ (negedge clk);
            // Read
         end   
        // Read
        for(count = 0; count < 20; count ++) begin
            re_b = 1;
            @ (negedge clk);
            @ (negedge clk);
            adr_b =  count;
            re_b = 0;
            @ (negedge clk);
            // Read
         end
   end
	 
 
  
   integer idx;

   initial begin: TEST_CASE
     $dumpfile("dpram_TB.vcd");
     $dumpvars(-1, dpram_TB);

     for(idx = 0; idx < 32; idx = idx +1)  $dumpvars(0, dpram_TB.uut.ram[idx]);


     #(PERIOD*150) $finish;
   end

endmodule

