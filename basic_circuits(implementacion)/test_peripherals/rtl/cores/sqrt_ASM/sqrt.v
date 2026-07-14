module sqrt(clk , rst , init , A , result , done);

  input         rst;
  input         clk;
  input         init;
  input  [15:0] A;
  output [15:0] result;
  output        done;

  wire w_sh;
  wire w_ld;
  wire w_lda2;
  wire w_ld_tmp;
  wire w_z;
  wire w_r0;

  wire [15:0] w_tmp;
  wire [15:0] w_lda_out;
  wire [15:0] w_lda2_in;

  lsr2 lsr20    (.clk(clk), .rst_ld(w_ld), .shift(w_sh), .lda2(w_lda2), .in_R1(A), .in_R2(w_lda2_in), .out_R(w_lda_out));
  lsr lsr_R     (.clk(clk), .reset(w_ld), .in_A(16'h0000),  .shift(w_sh), .load(1'b0),      .load_R0(w_lda2), .in_bit(w_r0), .out_r(result));
  lsr lsr_TMP   (.clk(clk), .reset(w_ld), .in_A(result),    .shift(1'b0), .load(w_ld_tmp) , .load_R0(1'b0),   .in_bit(1'b0), .out_r(w_tmp));
  addc2 addsub0 (.in_A(w_lda_out), .in_B({w_tmp[14:0], 1'b1}), .Result(w_lda2_in));
  count count0  (.clk(clk), .ld(w_ld) , .dec(w_sh), .z(w_z));
  control_sqrt control0 (.clk(clk), .rst(rst), .init(init), .msb(w_lda2_in[15]), .z(w_z), .done(done), .ld_tmp(w_ld_tmp), .r0(w_r0), .sh(w_sh), .ld(w_ld), .lda2(w_lda2));

endmodule


