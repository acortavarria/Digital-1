`timescale 1ns / 1ps
`define SIMULATION

module BcdToBin_Top_TB;

reg clk;
reg reset;
reg init;
reg [15:0] bcd;
wire [12:0] bin;
wire done;

BcdToBin_Top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .bcd(bcd),
        .bin(bin),
        .done(done)
    );

parameter PERIOD          = 40;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET          = 0;

initial begin
        #OFFSET;
forever begin
clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
end
end

initial begin
#0 reset = 0; init = 0; bcd = 16'd0;
        @(negedge clk);
reset = 1;
        @(negedge clk);
reset = 0;
        @(negedge clk);  
bcd = 16'h0123;
init = 1;         
        @(negedge clk);   
init = 0;         
        @(negedge done);  
#200;             
        @(negedge clk);   
bcd = 16'h4095;
init = 1;
        @(negedge clk);
init = 0;
        @(negedge done);
#200;

        @(negedge clk);
bcd = 16'h0555;
init = 1;
        @(negedge clk);
init = 0;
        @(negedge done);
#200;
$finish; 
end

initial begin: TEST_CASE
$dumpfile("BcdToBin_Top_TB.vcd");
$dumpvars(-1, uut);
        #(200000) $finish; 
end

endmodule
