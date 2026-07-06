module sumador32 (
    input clk,
    input rst,           
    input sum,              
    input [31:0] A,
    input [31:0] B,
    output reg [32:0] result
);

    always @(posedge clk) begin
        if (rst) begin
            result <= 32'd0;
        end else if (sum) begin
           
            result <= A + B; 
        end
    end

endmodule
