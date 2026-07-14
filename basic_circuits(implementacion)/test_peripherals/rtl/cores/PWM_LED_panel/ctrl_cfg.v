module ctrl_cfg #(
  parameter NUM_DRVS = 8,
  parameter DELAY    = 16
)(
    input             clk,
    input             rst,
    input             send_config,
    input             done_latch,
    output  reg       st_lat,
    output  reg       ld_cfg,
    output  reg       sh_cfg,
    output  reg [3:0] latches,

    output   reg      ld_out,
    output   reg      sh_out,
    input             done_out,
    output   reg      done_configure
);

parameter START                 = 5'b00000;
parameter WAIT_SEND_LATCH1      = 5'b00001;
parameter SEND_CFG_LOOP         = 5'b00010;
parameter SEND_PRE_ACT          = 5'b00011;
parameter START_SEND_CFG        = 5'b00100;
parameter WAIT_SEND_CFG_DATA    = 5'b00101;
parameter SET_NEXT_CFG_DATA     = 5'b00110;
parameter SEND_CFG_LATCHES      = 5'b00111;
parameter WAIT_SEND_CFG_LATCHES = 5'b01000;
parameter SEND_CFG_ALL_DRIVERS  = 5'b01001;
parameter NEXT_CFG_DATA_DELAY   = 5'b01010;
parameter WAIT_END_PREACT_CMD   = 5'b01011;
parameter SEND_PREACT_CMD       = 5'b01100;
parameter END_CONFIGURE         = 5'b01101;


parameter SEND_EN_CHAN          = 5'b01110;
parameter WAIT_END_SEND_CHAN    = 5'b01111;
parameter SEND_VSYNC            = 5'b10000;
parameter WAIT_END_VSYNC        = 5'b10001;



reg [4:0] state;
reg [3:0] num_latches;
reg [3:0] num_drivers;
reg [4:0] count_delay;

always @(posedge clk) begin
  if(rst) begin
    state        = START;
    latches     <= 14;
    num_drivers  = 0;
    count_delay <= 0;
  end
  else begin
    case(state)
      START:begin
        if(send_config)
          state      = SEND_PRE_ACT;
        else
          state      = START;
        latches     <= 14;
        num_latches <= 2;
      end

      SEND_PRE_ACT: begin   //PRE_ACT COMMAND
        latches <= 14;
        state    = WAIT_SEND_LATCH1;
      end

      WAIT_SEND_LATCH1:begin  // WAIT end latches
        latches <= 14;
        if (done_latch)
          state = SEND_EN_CHAN;
        else
          state = WAIT_SEND_LATCH1;
      end


      SEND_EN_CHAN: begin   //PRE_ACT COMMAND
        latches <= 12;
        state    = WAIT_END_SEND_CHAN;
      end

      WAIT_END_SEND_CHAN:begin  // WAIT end latches
        latches <= 12;
        if (done_latch)
          state = SEND_VSYNC;
        else
          state = WAIT_END_SEND_CHAN;
      end

      SEND_VSYNC: begin   //PRE_ACT COMMAND
        latches <= 3;
        state    = WAIT_END_VSYNC;
      end

      WAIT_END_VSYNC:begin  // WAIT end latches
        latches <= 3;
        if (done_latch)
          state = START_SEND_CFG;
        else
          state = WAIT_END_VSYNC;
      end

      START_SEND_CFG:begin  // Load config register
        state    = SEND_PREACT_CMD;
        latches <= 2;
      end

      SEND_PREACT_CMD:begin
        latches <= 14;
        state    = WAIT_END_PREACT_CMD;
      end

      WAIT_END_PREACT_CMD:
      begin
        latches <= 14;
        if (done_latch)
          state = SEND_CFG_LOOP;
        else
          state = WAIT_END_PREACT_CMD;
      end



      SEND_CFG_LOOP:begin  // Shift configuration data
        state    = WAIT_SEND_CFG_DATA;
      end

      WAIT_SEND_CFG_DATA:begin
        if(done_out)
          state = SEND_CFG_ALL_DRIVERS;
        else
          state = WAIT_SEND_CFG_DATA;
      end

      SEND_CFG_ALL_DRIVERS:begin
        num_drivers  <= num_drivers + 1;
        if(num_drivers == NUM_DRVS) begin
          state = SEND_CFG_LATCHES;
          num_drivers <= 0;
        end
        else
          state = SEND_CFG_LOOP;

      end

      SEND_CFG_LATCHES:begin
        latches     <= num_latches;
        state = WAIT_SEND_CFG_LATCHES;
      end

      WAIT_SEND_CFG_LATCHES:begin
        if (done_latch)
          state = SET_NEXT_CFG_DATA;
        else
          state = WAIT_SEND_CFG_LATCHES;
      end



      SET_NEXT_CFG_DATA:begin
        num_latches <= num_latches + 2;
        if(num_latches == 10)
          state = END_CONFIGURE;
        else
          state = NEXT_CFG_DATA_DELAY;
      end


      NEXT_CFG_DATA_DELAY:begin
        if(count_delay == DELAY) begin
          state = SEND_PREACT_CMD;
          count_delay <= 0;
        end else begin
          count_delay <= count_delay +1;
          state        = NEXT_CFG_DATA_DELAY;
        end
      end

      END_CONFIGURE:begin
        state = START;
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
        st_lat  = 1;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_PRE_ACT: begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      WAIT_SEND_LATCH1:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_EN_CHAN:begin
        st_lat  = 1;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end


      WAIT_END_SEND_CHAN:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_VSYNC:begin
        st_lat  = 1;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      WAIT_END_VSYNC:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      START_SEND_CFG:begin
        st_lat  = 0;
        ld_cfg  = 1;
        sh_cfg  = 0;
        ld_out  = 1;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_CFG_LOOP:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 1;
        done_configure = 0;
      end
      WAIT_SEND_CFG_DATA:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_CFG_LATCHES:begin
        st_lat  = 1;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      WAIT_SEND_CFG_LATCHES: begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SEND_CFG_ALL_DRIVERS:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 1;
        done_configure = 0;
      end

      SEND_PREACT_CMD:begin
        st_lat  = 1;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      WAIT_END_PREACT_CMD:
      begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      SET_NEXT_CFG_DATA:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 1;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      NEXT_CFG_DATA_DELAY:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end

      END_CONFIGURE:begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 1;
      end

      default: begin
        st_lat  = 0;
        ld_cfg  = 0;
        sh_cfg  = 0;
        ld_out  = 0;
        sh_out  = 0;
        done_configure = 0;
      end
    endcase

end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    START       : state_name = "START";
    WAIT_SEND_LATCH1      : state_name = "WAIT_SEND_LATCH1";
    SEND_CFG_LOOP         : state_name = "SEND_CFG_LOOP";
    SEND_PRE_ACT          : state_name = "SEND_PRE_ACT";
    START_SEND_CFG        : state_name = "START_SEND_CFG";
    WAIT_SEND_CFG_DATA    : state_name = "WAIT_SEND_CFG_DATA";
    SET_NEXT_CFG_DATA     : state_name = "SET_NEXT_CFG_DATA";
    SEND_CFG_LATCHES      : state_name = "SEND_CFG_LATCHES";
    WAIT_SEND_CFG_LATCHES : state_name = "WAIT_SEND_CFG_LATCHES";
    SEND_CFG_ALL_DRIVERS  : state_name = "SEND_CFG_ALL_DRIVERS";
    NEXT_CFG_DATA_DELAY   : state_name = "NEXT_CFG_DATA_DELAY";
    WAIT_END_PREACT_CMD   : state_name = "WAIT_END_PREACT_CMD";
    SEND_PREACT_CMD       : state_name = "SEND_PREACT_CMD";
    END_CONFIGURE         : state_name = "END_CONFIGURE";
    SEND_EN_CHAN          : state_name = "SEND_EN_CHAN";
    WAIT_END_SEND_CHAN    : state_name = "WAIT_END_SEND_CHAN";
    SEND_VSYNC            : state_name = "SEND_VSYNC";
    WAIT_END_VSYNC        : state_name = "WAIT_END_VSYNC";
  endcase
end
`endif




endmodule
