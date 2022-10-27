`include "encoder16to4.v"

module encoder16to4_tb();

reg [15:0]encoder_in;
wire valid;
wire [3:0]encoder_out;

encoder16to4 iencoder16to4(encoder_in,valid,encoder_out);



initial begin
    $monitor("in=%b; valid=%b; out=%b", encoder_in, valid, encoder_out);
    $dumpfile("encoder16to4_tb.vcd");
    $dumpvars(0,encoder16to4_tb);
     
     encoder_in=16'b0000000000000000;#10; 
     encoder_in=16'b0000000000000001;#10;
     encoder_in=16'b0000000000000010;#10; 
     encoder_in=16'b0000000000000100;#10;  
     encoder_in=16'b0000000000001000;#10;
     encoder_in=16'b0000000000010000;#10; 
     encoder_in=16'b1000000000000000;#10;
     encoder_in=16'b1000010001000000;#10;
     encoder_in=16'b1000010001000100;#10;  
     encoder_in=16'b1000010011000100;#10;
     
     $finish;

end
endmodule

//iverilog -o encoder16to4_tb.vvp encoder16to4_tb.v
//vvp encoder16to4_tb.vvp