module bcd2bin(clk , rst , init , A , result , done);

  input         rst;
  input         clk;
  input         init;
  input  [19:0] A;
  output [15:0] result;
  output        done;

  wire w_sh;
  wire w_ld;
  wire w_sel;
  wire w_ld_msb;
  wire w_add;
  wire w_z;
  wire [4:0] w_LD;
  wire [4:0] w_MSB;

  wire [3:0] w_uni;
  wire [3:0] w_dec;
  wire [3:0] w_cen;
  wire [3:0] w_umi;
  wire [3:0] w_dmi;
  wire [19:0] w_ld_in;
  wire [19:0] w_MUX;

  assign w_MSB ={ w_ld_in[19], w_ld_in[15], w_ld_in[11], w_ld_in[7], w_ld_in[3] };

  rsr4 rsr40        ( .clk(clk), .rst_ld(w_ld), .shift(w_sh), .lda2(w_LD), .in_R1(A), .in_R2(w_ld_in), .out_R({w_dmi, w_umi, w_cen, w_dec, w_uni}), .out_R2(result) );
  mux mux0          ( .in1(4'b1101), .in2(4'b1011), .out(w_MUX[3:0]),   .sel(w_sel) );
  mux mux1          ( .in1(4'b1101), .in2(4'b1011), .out(w_MUX[7:4]),   .sel(w_sel) );
  mux mux2          ( .in1(4'b1101), .in2(4'b1011), .out(w_MUX[11:8]),  .sel(w_sel) );
  mux mux3          ( .in1(4'b1101), .in2(4'b1011), .out(w_MUX[15:12]), .sel(w_sel) );
  mux mux4          ( .in1(4'b1101), .in2(4'b1011), .out(w_MUX[19:16]), .sel(w_sel) );
  add_sub_c2 comp0  ( .in_A(w_uni), .in_B(w_MUX[3:0]),   .Result(w_ld_in[3:0])   );
  add_sub_c2 comp1  ( .in_A(w_dec), .in_B(w_MUX[7:4]),   .Result(w_ld_in[7:4])   );
  add_sub_c2 comp2  ( .in_A(w_cen), .in_B(w_MUX[11:8]),  .Result(w_ld_in[11:8])  );
  add_sub_c2 comp3  ( .in_A(w_umi), .in_B(w_MUX[15:12]),  .Result(w_ld_in[15:12]) );
  add_sub_c2 comp4  ( .in_A(w_dmi), .in_B(w_MUX[19:16]), .Result(w_ld_in[19:16]) );
  reg_msb    reg0   ( .clk(clk), .reset(w_ld), .in(w_MSB), .out(w_LD), .ld(w_ld_msb), .oe(w_add) );

  cnt_bin2bcd count0 ( .clk(clk), .ld(w_ld) , .dec(w_sh), .z(w_z));
  ctrl_b2b control0 ( .clk(clk), .rst(rst), .init(init), .done(done), .sh(w_sh), .ld(w_ld), .sel(w_sel), .ld_msb(w_ld_msb), .add(w_add), .z(w_z) );

endmodule

