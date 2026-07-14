module blink(clk, rst, LED);
input      clk;
input      rst;
output     LED;

reg  [26:0] counter;

//assign LED = ~counter[23];  //12MHz
assign LED = ~counter[21];    //25MHz

always @(posedge clk ) begin
    if (rst)
      counter <= 0;
    else
      counter <= counter + 1;
end


endmodule
