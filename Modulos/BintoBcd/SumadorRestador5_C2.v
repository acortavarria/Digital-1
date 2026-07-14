module SumadorRestador_C2_5b (
    input sum,
    input restar,
    input [4:0] Aext,
    input [4:0] B,
    output reg [4:0] result
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
