module RegistroAext (
    input clk,
    input rst,
    input shft,
    input upd_Aext,        
    input [15:0] in_A,     
    input [16:0] alu_in,   
    output reg [16:0] Aext,
    output reg [15:0] A
);
    always @(posedge clk) begin
        if (rst) begin
            Aext <= 17'd0;
            A    <= in_A;
        end 
        else if (shft) begin
            {Aext, A} <= {Aext, A}<<1;
        end 
        else if (upd_Aext) begin
            
            Aext <= alu_in;
        end
    end
endmodule