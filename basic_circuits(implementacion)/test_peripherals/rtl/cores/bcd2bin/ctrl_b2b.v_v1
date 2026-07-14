module ctrl_b2b( clk , rst , init, done, sh, ld, sel, ld_msb, add, z );
           
           



 input       clk;
 input       rst;
 input       init;
 input       z;


 output reg sh;
 output reg ld;
 output reg sel;
 output reg ld_msb;
 output reg add;
 output reg done;

 parameter START     = 3'b000;
 parameter CHECK     = 3'b001;
 parameter SHIFT_DEC = 3'b010;
 parameter ADD       = 3'b011;
 parameter LOAD_A2   = 3'b100;
 parameter END1      = 3'b101;

 
 reg [2:0] state;
 reg [3:0] count;

always @(posedge clk) begin
  if (rst) begin
    state = START;
    count = 0;
  end else begin
  case(state)

    START:begin
      if(init)
        state = SHIFT_DEC;
      else
        state = START;
    end

    SHIFT_DEC: begin
      state = CHECK;
    end

    CHECK: begin

      if(z)
        state = END1;
      else
        state = LOAD_A2;


    end

    LOAD_A2: begin
      state = ADD;
    end

    ADD: begin
      state = SHIFT_DEC;
    end

    END1: begin
      count = count + 1;
      state = (count>9) ? START : END1;
    end

    default: state = START;
   endcase
  end
end


always @(*) begin
  case(state)
    START: begin
      done   = 0;
      ld_msb = 0;
      sel    = 0;
      sh     = 0;
      ld     = 1;
      add    = 0;
    end


    SHIFT_DEC: begin
      done   = 0;
      ld_msb = 1;
      sel    = 1;
      sh     = 1;
      ld     = 0;
      add    = 0;
    end

    CHECK: begin
      done   = 0;
      ld_msb = 1;
      sel    = 1;
      sh     = 0;
      ld     = 0;
      add    = 0;
    end


    LOAD_A2: begin
      done   = 0;
      ld_msb = 0;
      sel    = 0;
      sh     = 0;
      ld     = 0;
      add    = 1;
    end

    ADD: begin
      done   = 0;
      ld_msb = 0;
      sel    = 0;
      sh     = 0;
      ld     = 0;
      add    = 0;
    end

    END1: begin
      done   = 1;
      ld_msb = 0;
      sel    = 0;
      sh     = 0;
      ld     = 0;
      add    = 0;
    end

  endcase
end



`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    START     : state_name = "START";
    CHECK     : state_name = "CHECK";
    SHIFT_DEC : state_name = "SHIFT_DEC";
    ADD       : state_name = "ADD";
    LOAD_A2   : state_name = "LOAD_A2";
    END1      : state_name = "END1";
  endcase
end
`endif

endmodule
