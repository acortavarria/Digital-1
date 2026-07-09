module contador (
    input clk,
    input rst,
    input en,                       
    output reg [4:0] count    
);

    always @(posedge clk) begin
        if (rst)
            count <= 0; 
        else if (en)
            count <= count + 1'b1;  
    end

endmodule