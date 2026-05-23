// =============================================================
// Module: shift_register
// Description: N-bit register with parallel load and shift.
//   DIR=1 → left  shift (A REG: A << 1)
//   DIR=0 → right shift (B REG: B >> 1, LSB disponible)
// =============================================================
module shift_register #(
    parameter N   = 8,
    parameter DIR = 0
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         LD,
    input  wire         SHFT,
    input  wire [N-1:0] D,
    output reg  [N-1:0] Q,
    output wire         LSB
);
    assign LSB = Q[0];

    always @(posedge clk or posedge rst) begin
        if (rst)        Q <= {N{1'b0}};
        else if (LD)    Q <= D;
        else if (SHFT) begin
            if (DIR == 1) Q <= {Q[N-2:0], 1'b0};   // A << 1
            else          Q <= {1'b0, Q[N-1:1]};    // B >> 1
        end
    end
endmodule
