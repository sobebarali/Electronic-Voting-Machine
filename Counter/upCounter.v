module upCounter(clk,resetCounter,count_in,count_out);

input clk;
input resetCounter;
input count_in;
output reg [9:0]count_out;
 
always @ (posedge clk) begin
 if (resetCounter)
  count_out <= 0;
 else if (count_in)
  count_out <= count_out + 1;
end   

endmodule