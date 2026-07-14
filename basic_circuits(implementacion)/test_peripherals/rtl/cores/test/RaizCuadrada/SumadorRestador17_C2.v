module SumadorRestador_C2 (
    input sum,
    input restar,
    input [16:0] Aext,
    input [16:0] B,
    output reg [16:0] result
);

    always @(*) begin
        if (sum) begin
            result = Aext + B;
        end 
        else if (restar) begin
            
            result = Aext + (~B) + 1; 
        end 
        else begin
            result = Aext; 
        end
    end
endmodule