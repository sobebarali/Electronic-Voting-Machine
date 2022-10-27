`include "votingMachine.v"
`timescale 1ms/1ms
module votingMachine_tb();

reg clk;
reg[1:0] mode;
reg start;
reg[15:0] encoder_in;
wire pulse;
wire [9:0] result;

//Different Modes
localparam  resetMode = 2'b00,
            votingMode = 2'b01,
            individualCountMode = 2'b10,
            totalCountMode =2'b11;


//encoder
wire valid;
wire [3:0] encoder_out;

//monostable multivibrator
wire resetMultibrator;
wire trigger;

//pipo1 
wire resetPIPO1;
wire [3:0] pipo1_in;
wire load1;
wire ok;
wire [3:0] pipo1_out;

//mux1
wire[3:0] a;
wire[4:0] b;
wire sel;  
wire[4:0] mux1_out;

//counter
wire count_in;
wire [9:0]count_out;

// RAM
wire wr_en;
wire resetRam;
wire [9:0] data_in;
wire [4:0] addr;
wire [9:0] data_out;

//demux
wire[9:0] demux_in;
wire selD;
wire[9:0] out1;
wire[9:0] out2;

//adder
wire [9:0] adder_in;
wire [9:0] adder_out;

//mux2
wire[9:0] x;
wire[9:0] y;  
wire[9:0] mux2_out;


fsm ifsm(.clk(clk),.mode(mode),.start(start),.pulse(pulse),.encoder_in(encoder_in),.resetMultibrator(resetMultibrator),.resetPIPO1(resetPIPO1),.resetRam(resetRam),.load1(load1),.sel(sel),.wr_en(wr_en),.count_in(count_in),.selD(selD));
datapath idatapath(.clk(clk),.encoder_in(encoder_in),.resetRam(resetRam),.load1(load1),.sel(sel),.selD(selD),.wr_en(wr_en),.resetPIPO1(resetPIPO1),.resetMultibrator(resetMultibrator),.count_in(count_in),.pulse(pulse),.result(result));
votingMachine i222(.clk(clk),.mode(mode),.start(start),.encoder_in(encoder_in),.result(result));

initial begin
clk=0;
forever
#5 clk= ~clk;
end

integer i;

initial begin
    $monitor("Mode:%b Start:%b write:%b Read:%b ResetRam:%b ",mode,start,wr_en,wr_en,resetRam);
    $dumpfile("votingMachine_tb.vcd");
    $dumpvars(0,votingMachine_tb);

 
    mode=0;
    start=0;
    encoder_in=0;
    #15;

    mode=resetMode;
    #15;
    start=1'b1;
    #15;
    start=1'b0;
    #15;

    //candidate 0 = 30
    //candidate 1 = 45
    //candidate 2 = 16
    //candidate 3 = 33
    //candidate 4 = 56
    //candidate 5 = 24 
    //candidate 6 = 88
    //candidate 7 = 28
    //candidate 8 = 48
    //candidate 9 = 76
    //candidate 10 = 34
    //candidate 11 = 43
    //candidate 12 = 50
    //candidate 13 = 55
    //candidate 14 = 35
    //candidate 15 = 49

    //total count = 710

    mode=votingMode;
    #10;

    //giving 30 votes to candidate 0
    for(i=1; i<=30 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000000001;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end
    
    //giving 45 votes to candidate 1
    for(i=1; i<=45 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000000010;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 16 votes to candidate 2
    for(i=1; i<=16 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000000100;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end
    
    //giving 33 votes to candidate 3
    for(i=1; i<=33 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000001000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 56 votes to candidate 4
    for(i=1; i<=56; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000010000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 24 votes to candidate 5
    for(i=1; i<=24; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000000100000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    
    //giving 88 votes to candidate 6
    for(i=1; i<=88; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000001000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

     //giving 28 votes to candidate 7
    for(i=1; i<=28 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000010000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 48 votes to candidate 8
    for(i=1; i<=48 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000000100000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 76 votes to candidate 9
    for(i=1; i<=76; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000001000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 34 votes to candidate 10
    for(i=1; i<=34; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000010000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 43 votes to candidate 11
    for(i=1; i<=43; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0000100000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 50 votes to candidate 12
    for(i=1; i<=50; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0001000000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 55 votes to candidate 13
    for(i=1; i<=55; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0010000000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 35 votes to candidate 14
    for(i=1; i<=35 ; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b0100000000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end

    //giving 49 votes to candidate 15
    for(i=1; i<=49; i = i + 1) begin
        start=1'b1;
        encoder_in=16'b1000000000000000;
        #20;
        start=1'b0;
        encoder_in=16'b0000000000000000;
        #110;
    end
    
    
    mode=individualCountMode;
    #10;

    //Reading Candiate 1 vote count
    start=1'b1;
    encoder_in=16'b0000000000000001;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 2 vote count
    start=1'b1;
    encoder_in=16'b0000000000000010;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 3 vote count
    start=1'b1;
    encoder_in=16'b0000000000000100;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 4 vote count
    start=1'b1;
    encoder_in=16'b0000000000001000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 5 vote count
    start=1'b1;
    encoder_in=16'b0000000000010000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 6 vote count
    start=1'b1;
    encoder_in=16'b0000000000100000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 7 vote count
    start=1'b1;
    encoder_in=16'b0000000001000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 8 vote count
    start=1'b1;
    encoder_in=16'b0000000010000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 9 vote count
    start=1'b1;
    encoder_in=16'b0000000100000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 10 vote count
    start=1'b1;
    encoder_in=16'b0000001000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 11 vote count
    start=1'b1;
    encoder_in=16'b0000010000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 12 vote count
    start=1'b1;
    encoder_in=16'b0000100000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 13 vote count
    start=1'b1;
    encoder_in=16'b0001000000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;
    
    //Reading Candiate 14 vote count
    start=1'b1;
    encoder_in=16'b0010000000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading Candiate 15 vote count
    start=1'b1;
    encoder_in=16'b0100000000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;
    
    //Reading Candiate 16 vote count
    start=1'b1;
    encoder_in=16'b1000000000000000;
    #20;
    start=1'b0;
    encoder_in=16'b0000000000000000;
    #110;

    //Reading total count
    mode=totalCountMode;
    #10;
    start=1'b1;
    #20;
    start=1'b0;    


    
    #100;
    $finish;
    
end    

endmodule

//iverilog -o votingMachine_tb.vpp votingMachine_tb.v
//vvp votingMachine_tb.vpp
//gtkwave