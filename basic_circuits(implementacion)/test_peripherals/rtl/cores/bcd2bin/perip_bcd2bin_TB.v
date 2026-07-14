`timescale 1ns / 1ps

`define SIMULATION
module peripheral_bcd2bin_TB;
   reg clk;
   reg  reset;
   reg  start;
   reg [19:0]d_in;
   reg cs;
   reg [4:0]addr;
   reg rd;
   reg wr;
   wire [31:0]d_out;

	peripheral_bcd2bin uut (
      .clk(clk),
      .reset(reset),
      .d_in(d_in),
      .cs(cs),
      .addr(addr), // 4 LSB from j1_io_addr
      .rd(rd),
      .wr(wr),
      .d_out(d_out)
	);

   parameter PERIOD = 20;
   // Initialize Inputs
   initial begin  
      clk = 0; reset = 0; d_in = 0; addr = 16'h0000; cs=0; rd=0; wr=0;
   end
   // clk generation
   initial         clk <= 0;
   always #(PERIOD/2) clk <= ~clk;

   initial begin 
    forever begin
     // Reset 
     @ (posedge clk);
	  reset = 1;
	  @ (posedge clk);
	  reset = 0;
     #(PERIOD*4)
     // A operator
	  cs=1; rd=0; wr=1;
	  d_in = 20'h12345;
	  addr = 16'h0004;
     #(PERIOD)
     cs=0; rd=0; wr=0;
     #(PERIOD*4)
     cs=0; rd=0; wr=0;
     #(PERIOD*3)
     // Init signal
	  cs=1; rd=0; wr=1;
	  d_in = 16'h0001;
	  addr = 16'h000C;
     #(PERIOD)
     cs=0; rd=0; wr=0;
     @ (posedge peripheral_bcd2bin_TB.uut.bcd2bin0.done);
     // read done
     cs=1; rd=1; wr=0;
     addr = 16'h0014;
     #(PERIOD)
     cs=0; rd=0; wr=0;
     #(PERIOD)
     // read data	
     cs=1; rd=1; wr=0;
     addr = 16'h0010;
     #(PERIOD);
     cs=0; rd=0; wr=0;
     #(PERIOD*30);   
    end
   end
	 

   initial begin: TEST_CASE
     $dumpfile("perip_bcd2bin_TB.vcd");
     $dumpvars(-1, peripheral_bcd2bin_TB);
     #(PERIOD*100) $finish;
   end

endmodule

