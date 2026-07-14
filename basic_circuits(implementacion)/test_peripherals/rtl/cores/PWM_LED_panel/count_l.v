module count_l#(
    parameter width = 5
    )(
    input   clk,
    input   start,
    input   [width:0] load,
    output  reg zero,
    output  reg done
);

parameter START    = 3'b000;
parameter DONE     = 3'b001;
parameter COUNT    = 3'b010;
parameter LOAD     = 3'b011;


reg [width:0] outc;
reg [2:0] state;

always @(posedge clk) begin
  if(start) begin
    state = START;
    outc  <= load;
    zero  <= 0;
    done  <= 0;
  end
  else begin
    case(state)
      START:begin
        outc  <= load;
        zero  <= 0;
        done  <= 0;
        state = COUNT;

      end

      COUNT:begin
        outc <= outc -1;
        done <= 0;
        if (outc == 0) begin
          state = DONE;
          zero <= 0;
        end
        else begin
          state = COUNT;
          zero  <= 1;
        end
      end

      DONE: begin
        done  <= 1;
        zero  <= 0;
        outc  <= 0;
        state = DONE;
      end

      default: begin
        outc <= 0;
        zero <= 0;
      end
    endcase


  end

end


endmodule
