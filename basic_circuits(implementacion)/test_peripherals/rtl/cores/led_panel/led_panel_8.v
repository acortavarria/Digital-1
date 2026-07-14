module led_panel_8(clk , rst , init, LP_CLK, LATCH, NOE, ROW, RGB0, RGB1);

    input         rst;
    input         clk;
    input         init;
    output        LP_CLK;
    output        LATCH;
    output        NOE;
    output  [4:0] ROW;
    output  [2:0] RGB0;
    output  [2:0] RGB1;


    wire w_ZR;
    wire w_ZC;
    wire w_ZD;
    wire w_RST_R;
    wire w_RST_C;
    wire w_RST_D;
    wire w_INC_R;
    wire w_INC_C;
    wire w_INC_D;
    wire [10:0] delay;

    parameter  DELAY = 10;

    wire [10:0] PIX_ADDR;
    wire [5:0]  COL ;

    reg clk1;

reg [4:0] clk_counter;
   always @(posedge clk) begin
      if (rst) begin
        clk_counter <= 0;
        clk1        <= 0;
      end else begin
         if(clk_counter == 2) begin
            clk1    <= ~clk1;
            clk_counter <= 0;
         end
         else
            clk_counter <= clk_counter + 1;
      end
   end

    assign PIX_ADDR = {ROW, COL};

    assign LP_CLK = clk1 & PX_CLK_EN;

    count #(.width(4))     count_row(   .clk(clk1), .reset(w_RST_R), .inc(w_INC_R), .outc(ROW), .zero(w_ZR) );
    count #(.width(5))     count_col(   .clk(clk1), .reset(w_RST_C), .inc(w_INC_C), .outc(COL), .zero(w_ZC) );
    count #(.width (10))   count_delay( .clk(clk1), .reset(w_RST_D), .inc(w_INC_D), .outc(delay));
    comp  #(.value(DELAY), .width(10) ) compa(.in1(delay), .out(w_ZD));
    memory                 mem0 (.clk(clk1), .address(PIX_ADDR), .rd(1'b1), .rdata({RGB0, RGB1}));
    ctrl_lp8 ctrl0 (.clk(clk1), .rst(rst), .init(1'b1), .ZR(w_ZR), .ZC(w_ZC), .ZD(w_ZD), .RST_R(w_RST_R), .RST_C(w_RST_C), .RST_D(w_RST_D),
                    .INC_R(w_INC_R),  .INC_C(w_INC_C), .INC_D(w_INC_D), .LATCH(LATCH), .NOE(NOE), .PX_CLK_EN(PX_CLK_EN)) ;

endmodule
