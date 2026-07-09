module comparador (
    input [4:0] in,
    input [4:0] COMP,    
    output equal                    
);

    
    assign equal = (in == COMP);

endmodule
