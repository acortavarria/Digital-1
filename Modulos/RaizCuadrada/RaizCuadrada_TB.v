`timescale 1ns / 1ps
`define SIMULATION

module Raiz_Top_TB;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] A;
    
    wire [15:0] Raiz;
    wire done;

   
    Raiz_Top uut (
        .clk(clk),
        .reset(reset),
        .init(init),
        .A(A),
        .Raiz(Raiz),
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
       
        #0 reset = 0; init = 0; A = 16'd0;
        
        
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        
        @(posedge clk);
        A = 16'd144;
        init = 1;
        
        @(posedge clk);
        init = 0; 
        
    
        @(posedge done);
        
        #2000;
        
        
        
        A = 16'd49;
        init = 1;
        @(posedge clk);
        init = 0;
        
        @(posedge done);
        #2000;
        
        
    end

    initial begin: TEST_CASE
        $dumpfile("Raiz_Top_TB.vcd");
        $dumpvars(-1, uut);
        #(200000) $finish; 
    end

endmodule
