module ctrl_lp8(
    input   clk,
    input   init,
    input   rst,
    input   ZR,
    input   ZC,
    input   ZD,
    output  reg RST_R,
    output  reg RST_C,
    output  reg RST_D,
    output  reg INC_R,
    output  reg INC_C,
    output  reg INC_D,
    output  reg LATCH,
    output  reg NOE,
    output  reg PX_CLK_EN
);

 parameter START       = 3'b000;
 parameter GET_PIXEL   = 3'b001;
 parameter INC_COL     = 3'b010;
 parameter ROW_READY   = 3'b100;
 parameter SEND_ROW    = 3'b011;
 parameter DELAY_ROW   = 3'b101;
 parameter INC_ROW     = 3'b110;
 parameter READY_FRAME = 3'b111;

 reg [2:0] state;


 always @(posedge clk) begin
  if (rst) begin
    state = START;
  end else begin
    case(state)
      START: begin
        if(init)
          state = GET_PIXEL;
        else
          state = START;
      end

      GET_PIXEL: begin
        state = INC_COL;
      end

      INC_COL: begin
        if(ZC)
          state = SEND_ROW;
        else 
          state = INC_COL;
      end


      SEND_ROW: begin
        state = DELAY_ROW;
      end

      DELAY_ROW: begin
        if(ZD)
          state = INC_ROW;
        else
          state = DELAY_ROW;
      end

      INC_ROW: begin
        state = READY_FRAME;
      end

      READY_FRAME: begin
        if(ZR)
          state = START;
        else
          state = GET_PIXEL;
      end

      default: state = START;
    endcase
  end
end

always @(*) begin
    case(state)
      START: begin
        RST_R = 0; RST_C = 0; RST_D = 0;
        INC_R = 0; INC_C = 0; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      GET_PIXEL: begin
        RST_R = 1; RST_C = 1; RST_D = 1;
        INC_R = 0; INC_C = 0; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      INC_COL: begin
        RST_R = 1; RST_C = 1; RST_D = 1;
        INC_R = 0; INC_C = 1; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 1;
      end

      SEND_ROW: begin
        RST_R = 1; RST_C = 1; RST_D = 1;
        INC_R = 0; INC_C = 0; INC_D = 0;
        LATCH = 1; NOE   = 0; PX_CLK_EN = 0;
      end

      DELAY_ROW: begin
        RST_R = 1; RST_C = 1; RST_D = 1;
        INC_R = 0; INC_C = 0; INC_D = 1;
        LATCH = 0; NOE   = 0; PX_CLK_EN = 0;
      end

      INC_ROW: begin
        RST_R = 1; RST_C = 0; RST_D = 0;
        INC_R = 1; INC_C = 0; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      READY_FRAME: begin
        RST_R = 1; RST_C = 1; RST_D = 1;
        INC_R = 0; INC_C = 0; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      default: begin
        RST_R = 0; RST_C = 0; RST_D = 0;
        INC_R = 0; INC_C = 0; INC_D = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

    endcase
end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    START       : state_name = "START";
    GET_PIXEL   : state_name = "GET_PIXEL";
    INC_COL     : state_name = "INC_COL";
    ROW_READY   : state_name = "ROW_READY";
    SEND_ROW    : state_name = "SEND_ROW";
    DELAY_ROW   : state_name = "DELAY_ROW";
    INC_ROW     : state_name = "INC_ROW";
    READY_FRAME : state_name = "READY_FRAME";

  endcase
end
`endif

endmodule
