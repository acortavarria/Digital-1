module Registro_Shift_BcdToBin (
    input clk,
    input rst,
    input sumi,
    input eval,
    input [15:0] bcd,
    input [15:0] bcd_adj_val,
    output reg [28:0] shift_reg
);
    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= {bcd, 13'd0};
        end else if (eval) begin
            shift_reg[28:13] <= bcd_adj_val;
        end else if (sumi) begin
            shift_reg <= shift_reg >> 1;
        end
    end
endmodule

