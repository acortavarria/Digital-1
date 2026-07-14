module Ajuste_BCD (
    input [15:0] bcd_in,
    output [15:0] bcd_out,
    output need_adj
);
    wire [3:0] u = bcd_in[3:0];
    wire [3:0] d = bcd_in[7:4];
    wire [3:0] c = bcd_in[11:8];
    wire [3:0] m = bcd_in[15:12];
    wire uu = (u >= 5);
    wire dd = (d >= 5);
    wire cc = (c >= 5);
    wire mm = (m >= 5);
    assign need_adj = (uu | dd | cc | mm);
    wire [3:0] u_next = uu ? (u + 3) : u;
    wire [3:0] d_next = dd ? (d + 3) : d;
    wire [3:0] c_next = cc ? (c + 3) : c;
    wire [3:0] m_next = mm ? (m + 3) : m;
    assign bcd_out = {m_next, c_next, d_next, u_next};
endmodule
module comparador (
    input [4:0] in, input [4:0] COMP, output equal                    
);
    assign equal = (in == COMP);
endmodule
module contador (
    input clk, input rst, input en, output reg [4:0] count    
);
    always @(posedge clk) begin
        if (rst) count <= 0; 
        else if (en) count <= count + 1'b1;  
    end
endmodule
 

