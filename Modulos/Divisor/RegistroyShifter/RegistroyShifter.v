module RegistroyShifter (
    input clk,
    input rst,      
    input shft,        
    input [15:0] in, 
    output reg [31:0] in_reg
);
    always @(posedge clk) begin
        if (rst)
            in_reg <= in;
        else if (shft)
            in_reg <= {in_reg[30:0], 1'b0}; 
    end
endmodule