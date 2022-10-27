`include "upCounter.v"

module upCounter_tb;
reg  clk, resetCounter,count_in;
wire [9:0]count_out;

upCounter iupCounter(.*);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $monitor("Time=%2d, Clock=%b, Reset=%b, count=%b \n",$time,clk,resetCounter,count_out);
    $dumpfile("upCounter_tb.vcd");
    $dumpvars(0, upCounter_tb);
    
    resetCounter=0;
    count_in=0;
    #10;

    resetCounter=1;
    #10;
    resetCounter=0;
    #10;
    count_in=1;
    #10;
    count_in=0;
    #10;
    count_in=1;
    #10;
    count_in=0;
    #10;
    count_in=1;
    #10;
    count_in=0;

    #50
    $finish;

end
endmodule

//iverilog -o upCounter_tb.vvp upCounter_tb.v
//vvp upCounter_tb.vvp
//gtkwave