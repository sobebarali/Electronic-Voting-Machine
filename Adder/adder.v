module adder(adder_in,adder_out);

input [9:0]adder_in;
output reg [9:0]adder_out;

always @(*) begin
    adder_out= adder_in+1;
end

endmodule