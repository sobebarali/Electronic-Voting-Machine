`include "PIPO.v"

module PIPO_tb;

    reg clk;
    reg reset;
    reg  [3:0]pipo_in;
    reg load;
    wire [3:0]pipo_out;
    
    PIPO iPIPO (.*);   

    initial begin
    clk=0;
    forever
    #5 clk= ~clk;
    end 
    
    initial begin
        $monitor("Reset=%b Input=%b, load=%b output=%b",reset,pipo_in,load,pipo_out);
        $dumpfile("PIPO_tb.vcd");
        $dumpvars(0, PIPO_tb);

        reset=0; pipo_in =0;load=0;#20;
       
        #10;reset=0; pipo_in =4'b1001;load=1;
        #10;reset=0; pipo_in =4'b1011;load=0;
        #10;reset=0; load=1;
        #10;reset=0; pipo_in =4'b0001;load=1;
        #10;reset=0; pipo_in =4'b1111;load=1;
        #10;reset=0; pipo_in =4'b1010;load=0;
        #10;reset=0; load=1;
        

        #200;
        $finish;
    end
    
    //iverilog -o PIPO_tb.vvp PIPO_tb.v
    //vvp PIPO_tb.vvp
    //gtkwave

endmodule