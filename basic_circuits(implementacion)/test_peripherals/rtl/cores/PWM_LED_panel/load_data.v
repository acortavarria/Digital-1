module load_data #(
    parameter width       = 128,
    parameter config0     = 16'h0008,
    parameter config1     = 16'h1f70,
    parameter config2     = 16'h6707,
    parameter config3     = 16'h40f7,
    parameter config4     = 16'h0040,
    parameter num_drivers = 8
)(
    input        clk,
    input        rst,
    output [5:0] out_data,
    output       dclk,
    output       latch_out,
    input        send_config,
    output       done_configure,
    input        send_data,
    output  reg  done_data
);

// CONFIG SIGNALS
wire sh_cfg;
wire ld_cfg;
wire [15:0] ser_cfg;

// LATCHES GENERATOR
wire st_lat;
wire [3:0] latches;
wire clk_en_latch;
wire done_latch;
reg pixel_clk_en;


// OUTPUT SHIFT REGISTER
wire ld_out;
wire sh_out;
wire done_out;
wire clk_en_out;


wire [15:0] ld_R0;
wire [15:0] ld_G0;
wire [15:0] ld_B0;
wire [15:0] ld_R1;
wire [15:0] ld_G1;
wire [15:0] ld_B1;


wire [15:0] ld_cfg_R0;
wire [15:0] ld_cfg_G0;
wire [15:0] ld_cfg_B0;
wire [15:0] ld_cfg_R1;
wire [15:0] ld_cfg_G1;
wire [15:0] ld_cfg_B1;


assign dclk = clk & (clk_en_latch | clk_en_out | pixel_clk_en);
assign latch_out = ( clk_en_latch | pixel_en_latch ) ;

lsr_config #( .width(width), .config0(config0), .config1(config1),
              .config2(config2), .config3(config3), .config4(config4))
            lsr_cfg0 (.clk(clk) , .shift(sh_cfg) , .load(ld_cfg) , .s_A(ser_cfg));

count_l    #( .width(3))   count_l0( .clk(clk), .start(st_lat), .load(latches), .zero(clk_en_latch), .done(done_latch));

ctrl_cfg   #(.NUM_DRVS(num_drivers), .DELAY(10)) ctr_cfg0( .clk(clk), .rst(rst), .send_config(send_config), .latches(latches), .st_lat(st_lat), .done_latch(done_latch),
                    .ld_cfg(ld_cfg), .sh_cfg(sh_cfg), .done_configure(done_configure),
                    .ld_out(ld_out), .sh_out(sh_out), .done_out(done_out) );


assign ld_R0 = ser_cfg;
assign ld_G0 = ser_cfg;
assign ld_B0 = ser_cfg;
assign ld_R1 = ser_cfg;
assign ld_G1 = ser_cfg;
assign ld_B1 = ser_cfg;

out_lsr  lsr_r0(  .clk(clk), .in_val(ld_R0), .load(ld_out), .shift(sh_out), .s_out(data_cfg[5]), .done(done_out), .clk_en(clk_en_out) );  // R0
out_lsr  lsr_g0(  .clk(clk), .in_val(ld_G0), .load(ld_out), .shift(sh_out), .s_out(data_cfg[4])  );  // G0
out_lsr  lsr_b0(  .clk(clk), .in_val(ld_B0), .load(ld_out), .shift(sh_out), .s_out(data_cfg[3])  );  // B0
out_lsr  lsr_r1(  .clk(clk), .in_val(ld_R1), .load(ld_out), .shift(sh_out), .s_out(data_cfg[2])  );  // R1
out_lsr  lsr_g1(  .clk(clk), .in_val(ld_G1), .load(ld_out), .shift(sh_out), .s_out(data_cfg[1])  );  // G1
out_lsr  lsr_b1(  .clk(clk), .in_val(ld_B1), .load(ld_out), .shift(sh_out), .s_out(data_cfg[0])  );  // B1




wire [5:0] data_cfg;
reg [5:0] pixel_data;

assign out_data = data_cfg | pixel_data;


reg [16:0] count_pixel ;
reg [5:0]  row_count;

reg pixel_en_latch;



parameter START         = 4'b0101;
parameter SEND_LATCH    = 4'b0001;
parameter SEND_DATA     = 4'b0010;
parameter LOOP          = 4'b0011;
parameter LOOP_SEND     = 4'b0100;

reg [3:0] state;  //2048

always @(negedge clk) begin
  if(rst) begin
    state           = START;
    pixel_data     <= 0;
    count_pixel    <= 0;
    pixel_clk_en   <= 0;
    pixel_en_latch <= 0;
    row_count      <= 0;
    done_data      <= 0;
  end
  else begin
    case(state)
      START:begin
        pixel_data     <= 0;
        count_pixel    <= 0;
        pixel_clk_en   <= 0;
        pixel_en_latch <= 0;
        row_count      <= 0;
        done_data      <= 0;
        if(send_data)
            state      = LOOP_SEND;
        else
            state      = START;
      end

      LOOP_SEND:begin
        pixel_clk_en   <= 1;
        pixel_en_latch <= 0;
        done_data      <= 0;
        pixel_data   <= count_pixel[9:4];
        count_pixel  <= count_pixel + 1;
        if(count_pixel==2048) begin
           state = SEND_LATCH;
           count_pixel  <= 0;
           row_count    <= row_count + 1;
        end else
           state = LOOP_SEND;
      end

      SEND_LATCH:begin
        pixel_en_latch <= 1;
        
        if(row_count == 32) begin
          state = START;
          done_data      <= 1;
        end else 
          state           = LOOP_SEND;
          
      end

    endcase
  end
end



endmodule
