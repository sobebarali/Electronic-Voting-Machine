`timescale 1ps/1ps
`include "mux21.v"

module mux21_tb;
reg  a, b , sel;
wire mux_out;

mux21 imux21(a,b,sel,mux_out);

initial begin
    $monitor("At time=%2d, a=%b, b=%b, select=%b, out=%b",$time,a,b,sel,mux_out);
    $dumpfile("mux21_tb.vcd");
    $dumpvars(0, mux21_tb);
   
    a=1; b=0; sel=0; #10;
    a=1; b=0; sel=1; #10;
    a=0; b=1; sel=0; #10;
    a=0; b=1; sel=1; #10;

    $finish;

end
endmodule


//iverilog -o mux21_tb.vvp mux21_tb.v
//vvp mux21_tb.vvp
//gtkwave