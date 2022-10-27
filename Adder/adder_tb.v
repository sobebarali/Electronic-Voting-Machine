`timescale 1ms/1ms
`include "adder.v"


module adder_tb();

reg [9:0]adder_in;
wire [9:0]adder_out;

adder iadder(adder_in,adder_out);

initial begin
    $monitor("adder_in=%b, adder_out=%b \n",adder_in,adder_out);
    $dumpfile("adder_tb.vcd");
    $dumpvars(0, adder_tb);

    adder_in=0;#10;
    adder_in=0;#10;
    adder_in=1;#10;
    adder_in=1;#10;
    adder_in=2;#10;
    adder_in=3;#10;
    adder_in=5;#10;
    $finish;

end

endmodule

//iverilog -o adder_tb.vvp adder_tb.v
//vvp adder_tb.vvp