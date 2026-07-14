module ctrl_show(
  input  clk,
  input  rst,
  input  init,
  input  z_c,
  input  z_o,
  input  z_z,
  output reg inc_o,
  output reg inc_z,
  output reg inc_c,

  output reg clk_en
);

 parameter START        = 3'b000;
 parameter NEXT_ROW     = 3'b001;
 parameter SET_ZERO     = 3'b010;
 parameter PULSE_GCLK   = 3'b011;
 parameter ENABLE_CLOCK = 3'b100;


reg [2:0] state;


always @(posedge clk) begin
  if(rst) begin
    state = START;
  end
  else begin
    case(state)
      START:begin
        if(init)
          state = SET_ZERO;
        else
          state = START;
      end

      NEXT_ROW: begin
        state = SET_ZERO;
      end

      SET_ZERO: begin
        if(z_z)
          state <= ENABLE_CLOCK;
        else
          state <= SET_ZERO;
      end

      ENABLE_CLOCK: begin
        state = PULSE_GCLK;
      end

      PULSE_GCLK: begin
        if(z_o)
          state = NEXT_ROW;
        else
          state = PULSE_GCLK;
      end

      default: begin
        state = START;
      end
    endcase
  end
end


always @(*) begin
    case(state)
      START: begin
        inc_c  = 0; inc_z = 0; inc_o = 0;
        clk_en = 0;
      end

      NEXT_ROW: begin
        inc_c  = 1; inc_z = 0; inc_o = 0;
        clk_en = 0;
      end

      SET_ZERO: begin
        inc_c  = 0; inc_z = 1; inc_o  = 0;
        clk_en = 0;
      end

      ENABLE_CLOCK: begin
        inc_c  = 0; inc_z = 0; inc_o  = 1;
        clk_en = 1;
      end

      PULSE_GCLK: begin
        inc_z  = 0; inc_o = 1;
        clk_en = 1;
        if(z_o) begin
          inc_c = 1;
        end
        else begin
          inc_c = 0;
        end
      end


      default: begin
        inc_c  = 0; inc_z = 0; inc_o = 0;
        clk_en = 0;
      end
    endcase
end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    START       : state_name = "START";
    SET_ZERO    : state_name = "SET_ZERO";
    PULSE_GCLK  : state_name = "PULSE_GCLK";
    NEXT_ROW    : state_name = "NEXT_ROW";
  endcase
end
`endif

endmodule
