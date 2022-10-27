module demux12 (demux_in,seselDl,out1,out2);
    input[9:0] demux_in;
    input selD;
    output reg[9:0] out1;
    output reg[9:0] out2;
   
    always @(*) begin
        case (selD)
            1'b0: out1 = demux_in;
            1'b1: out2 = demux_in; 
            default: begin
                out1=0;out2=0;
            end
        endcase     
    end
endmodule
