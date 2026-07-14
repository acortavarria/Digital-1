module RegistroCociente (
    input clk,
    input rst,
    input shft,
    input agg,
    output reg [15:0] C
);
    always @(posedge clk) begin
        if (rst) begin
            C <= 0;
        end else begin
            if (shft) begin
                C <= C<<1; 
            end
            if (agg) begin
                C[0] <= 1;
            end
        end
    end
endmodule