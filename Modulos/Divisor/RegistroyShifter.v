module RegistroyShifter (
    input clk,
    input rst,      
    input shft,        
    input [15:0] in, 
    output reg [16:0] in_reg // Ajustado a 17 bits
);
    always @(posedge clk) begin
        if (rst)
            in_reg <= {1'b0, in}; // Extensión segura a 17 bits sin signo
        else if (shft)
            in_reg <= {in_reg[15:0], 1'b0}; 
    end
endmodule