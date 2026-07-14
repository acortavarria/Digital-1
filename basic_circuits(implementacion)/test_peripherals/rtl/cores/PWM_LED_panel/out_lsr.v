module out_lsr(clk , shift , in_val, load , s_out, done, clk_en);
  input         clk;
  input [15:0]  in_val;
  input         load;
  input         shift;
  output wire   s_out;
  output reg    done;
  output reg    clk_en;

parameter START    = 3'b000;
parameter DONE     = 3'b001;
parameter COUNT    = 3'b010;
parameter LOAD     = 3'b011;


reg [15:0] outc;
reg  [5:0] bits;
reg [2:0] state;
assign s_out = outc[0];

always @(posedge clk) begin
  if(load) begin
    state = START;
  end
  else begin
    case(state)
      START:begin
        outc <= in_val;
        bits <= 0;
        if(shift)
          state = COUNT;
        else
          state = START;
      end


      COUNT:begin
        if (bits == 5'h10) begin
          state   = DONE;
          bits    = 0;
        end
        else begin
          state       = COUNT;
          outc[15:0] <= {1'b0, outc[15:1]};
          bits       <= bits + 1;
        end
      end

      DONE: begin
        outc    <= 0;
        state    = START;
        bits    <= 0;
      end

      default: begin
        outc    <= 0;
        bits    <= 0;
        state    = START;
      end
    endcase
  end
end



always @(*) begin
    case(state)
      START: begin
        done   <= 0;
        clk_en <= 0;
      end
      COUNT:begin
        done   <= 0;
        clk_en <= 1;
      end
      DONE: begin
        done   <= 1;
        clk_en <= 0;
      end
      default: begin
        done   <= 0;
        clk_en <= 0;
      end
    endcase
end

endmodule
