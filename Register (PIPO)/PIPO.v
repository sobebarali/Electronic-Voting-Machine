
module PIPO (clk,reset,pipo_in,load,pipo_out);

input clk;
input reset;
input [3:0] pipo_in;
input load;
output reg [3:0] pipo_out;


always @(posedge clk)
begin
    if (reset)
    begin
        pipo_out <= 4'b0000;
    end
    else if (load)
    begin
        pipo_out <= pipo_in;
    end
end

endmodule

