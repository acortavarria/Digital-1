module show_data #(
    parameter pulses_on  = 74,
    parameter pulses_off = 27
)(
    input         clk,
    input         rst,
    input         init,
    output [4:0 ] outc,
    output        gclk
);

   wire inc_o;
   wire inc_c;
   wire inc_z;
   wire z_o;
   wire z_c;
   wire z_z;
   wire clk_en;

   assign gclk = clk & clk_en;

   ctrl_show   ctrl0 (.clk(clk), .rst(rst), .init(init), .z_c(z_c), .z_z(z_z), .z_o(z_o), .inc_o(inc_o), .inc_z(inc_z), .inc_c(inc_c), .clk_en(clk_en) );
   count #(.width (4), .limit(31)) count_col  (.clk(clk), .reset(rst), .inc(inc_c), .zero(z_c), .outc(outc));
   count #(.width (4), .limit(pulses_off)) count_zero (.clk(clk), .reset(rst), .inc(inc_z), .zero(z_z));
   count #(.width (6), .limit(pulses_on)) count_pulse(.clk(clk), .reset(rst), .inc(inc_o), .zero(z_o));


endmodule
