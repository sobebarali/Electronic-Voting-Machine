module mux21 (a,b,sel,mux_out);
    input a,b,sel;
    output reg mux_out;
   

    always @(*) begin
        case (sel)
            1'b0: mux_out = a;
            1'b1: mux_out = b; 
            default: mux_out = 0;
        endcase     
    end
endmodule


