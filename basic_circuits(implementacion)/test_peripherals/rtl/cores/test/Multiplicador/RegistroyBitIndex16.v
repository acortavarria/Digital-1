module RegistroyBitIndex16 (
    input clk,
    input rst,        
    input [15:0] in,
    input [4:0] i, 
    output in_i,                
    output reg [15:0] in_reg           
);
    always @(posedge clk) begin
        if (rst) 
            in_reg <= in;
    end
    
    
    assign in_i = in_reg[i]; 
endmodule