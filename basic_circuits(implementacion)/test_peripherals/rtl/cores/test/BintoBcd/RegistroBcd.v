module Registro_Shift_BCD (
    input clk,
    input rst,
    input sumi,
    input eval,
    input [12:0] bin,
    input [15:0] bcd_adj_in,
    output reg [28:0] shift_reg
);
    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= {16'd0, bin};
        end else if (eval) begin
            shift_reg[28:13] <= bcd_adj_in;
        end else if (sumi) begin
            shift_reg <= shift_reg << 1;
        end
    end
endmodule
