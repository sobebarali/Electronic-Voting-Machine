module votingMachine(clk,mode,start,encoder_in,result);

input clk;
input[1:0] mode;
input start;
input[15:0] encoder_in;
output[9:0] result;

//Different Modes
localparam  resetMode = 2'b00,
            votingMode = 2'b01,
            individualCountMode = 2'b10,
            totalCountMode =2'b11;


fsm ifsm(.clk(clk),.mode(mode),.start(start),.pulse(pulse),.encoder_in(encoder_in),.resetMultibrator(resetMultibrator),.resetPIPO1(resetPIPO1),.resetRam(resetRam),.load1(load1),.sel(sel),.wr_en(wr_en),.count_in(count_in),.selD(selD));
datapath idatapath(.clk(clk),.encoder_in(encoder_in),.resetRam(resetRam),.load1(load1),.sel(sel),.selD(selD),.wr_en(wr_en),.resetPIPO1(resetPIPO1),.resetMultibrator(resetMultibrator),.count_in(count_in),.pulse(pulse),.result(result));

endmodule

module datapath(clk,encoder_in,resetRam,load1,sel,selD,wr_en,resetPIPO1,resetMultibrator,count_in,pulse,result);
input clk;
input[15:0] encoder_in;
input resetRam;
input load1;
input sel;
input selD;
input wr_en;
input resetPIPO1;
input resetMultibrator;
input count_in;
output pulse;
output [9:0] result;

//Encoder
wire valid;
wire [3:0] encoder_out;

//monostable multivibrator
wire resetMultibrator;
wire trigger;

//pipo1 
wire resetPIPO1;
wire [3:0] pipo1_in;
wire load1;
wire [3:0] pipo1_out;

//mux1
wire[3:0] a;
wire[4:0] b;
wire sel;  
wire[4:0] mux1_out;

//counter
wire count_in;
wire [9:0]count_out;

//ram
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


encoder16to4 iencoder16to4(.encoder_in(encoder_in),.valid(trigger),.encoder_out(pipo1_in));
monostable imonostable(.clk(clk),.resetMultibrator(resetMultibrator),.trigger(trigger),.pulse(pulse)); 
PIPO1 iPIPO1(.clk(clk),.resetPIPO1(resetPIPO1),.pipo1_in(pipo1_in),.load1(load1),.pipo1_out(a));
counter icounter(.clk(clk),.resetRam(resetRam),.count_in(count_in),.count_out(y));
mux1 imux1(.a(a),.b(b),.sel(sel),.mux1_out(addr));
ram iram(.clk(clk),.wr_en(wr_en),.resetRam(resetRam),.data_in(data_in),.addr(addr),.data_out(demux_in));
demux12 idemux(.demux_in(demux_in),.selD(selD),.out1(adder_in),.out2(result));
adder iadder(.adder_in(adder_in),.adder_out(x));
mux2 imux2(.x(x),.y(y),.sel(sel),.mux2_out(data_in));

endmodule

module fsm(clk,mode,start,encoder_in,pulse,resetMultibrator,resetPIPO1,resetRam,load1,sel,wr_en,count_in,selD);
input clk;
input [1:0] mode;
input start;
input[15:0] encoder_in;
input pulse;
output reg resetMultibrator;
output reg resetPIPO1;
output reg resetRam;
output reg load1;
output reg sel;
output reg wr_en;
output reg count_in;
output reg selD;

reg [2:0] present_state, next_state;

//Different Modes
localparam  resetMode = 2'b00,
            votingMode = 2'b01,
            individualCountMode = 2'b10,
            totalCountMode =2'b11;

//State
localparam s0= 3'b000,
           s1= 3'b001,
           s2= 3'b010,
           s3= 3'b011,
           s4= 3'b100,
           s5= 3'b101,
           s6= 3'b110,
           s7= 3'b111; 

always @(posedge clk) begin
      present_state <= next_state;
end      

                     
always @(*) begin
      case(present_state)
         s0 :begin //mode selection,start,encoderin,reset
            resetMultibrator=1'b1;
            resetRam=1'b0;
            load1=1'b0;
            count_in=1'b0;
            resetPIPO1=1'b0;
               if (mode==resetMode) begin
                  if (start) begin
                      next_state = s1;
                  end
               end 
               else if(mode==votingMode) begin
                  if (start) begin
                      if (encoder_in) begin
                        next_state = s2;
                      end
                  end
               end
               else if(mode==individualCountMode)begin
                  if (start) begin
                      if (encoder_in) begin
                        next_state = s2;
                      end
                  end
               end
               else if(mode==totalCountMode) begin
                  if (start) begin
                      next_state = s6;
                  end
               end 
            end  
         s1 :begin //resetRam & counter
            resetRam=1'b1;
               if(resetRam)
               next_state = s0;
               else
               next_state = s1;
            end
          s2 :begin //loading vote 
            resetMultibrator=1'b0;
            resetPIPO1=1'b0;
            load1=1'b1;
            count_in='b1; 
            if(load1)
            next_state = s3;
            else
            next_state = s2;
          end
          s3: begin //selection & reading
            sel=1'b0;
            wr_en=1'b0;
            selD = 1'b0;
            load1=1'b0;
            count_in=1'b0;
            if(mode==votingMode & !wr_en)
            next_state = s4;
            else if(mode==individualCountMode & !wr_en)
            next_state = s5;
            else
            next_state = s3;
          end
          s4 :begin // writing during voting mode
            wr_en=1'b1;
            if(wr_en)
               next_state=s6;
            else
            next_state = s4;
         end 
         s5 : begin //waiting for pulse to become low && selecting demux
            wr_en=1'b0;
            selD = 1'b1;
            if(!pulse)
            next_state = s0;
            else
            next_state = s5;
         end
         s6 : begin //generating total count address and reading total count value
            sel=1'b1;
            wr_en=1'b0;
            if(mode == votingMode & sel)
            next_state = s7;
            else if(mode == totalCountMode & sel)
            next_state = s5;
            else
            next_state = s6;
         end
         s7 : begin //updating total count
            wr_en=1'b1;;
            if(wr_en)
            next_state=s5;
            else
            next_state = s7;
         end   
         default:begin
            present_state = s0; next_state = s0;
         end 
      endcase
end
endmodule

module encoder16to4 (encoder_in,valid,encoder_out);

input [15:0]encoder_in;
output reg valid;
output reg [3:0] encoder_out;

always @(*) begin
    case(encoder_in)
         16'b0000000000000001 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0000;
            end
         end  
         16'b0000000000000010 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0001;
            end
         end 
         16'b0000000000000100 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0010;
            end
         end 
         16'b0000000000001000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0011;
            end
         end 
         16'b0000000000010000 :begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0100;
            end
         end 
         16'b0000000000100000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0101;
            end
         end 
         16'b0000000001000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0110;
            end
         end 
         16'b0000000010000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b0111;
            end
         end 
         16'b0000000100000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1000;
            end
         end 
         16'b0000001000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1001;
            end
         end 
         16'b0000010000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1010;
            end
         end 
         16'b0000100000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1011;
            end
         end 
         16'b0001000000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1100;
            end
         end 
         16'b0010000000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1101;
            end
         end 
         16'b0100000000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1110;
            end
         end 
         16'b1000000000000000 : begin
            valid = 1'b1;
            if (valid) begin
               encoder_out =4'b1111;
            end
         end 
         default: begin
            valid=1'b0;encoder_out =4'b0000;
         end 
         endcase
    end
endmodule

module monostable(clk,resetMultibrator,trigger,pulse);
input clk;
input resetMultibrator;
input trigger;
output reg pulse = 0;

parameter PULSE_WIDTH = 10;
    
reg [4:0] count=0;

always @(posedge clk, posedge resetMultibrator) begin
        if (resetMultibrator) begin
                pulse <= 1'b0;
        end else if (trigger) begin
                pulse <= 1'b1;
        end else if (count == PULSE_WIDTH-1) begin
                pulse <= 1'b0;
        end
end

always @(posedge clk, posedge resetMultibrator) begin
        if(resetMultibrator) begin
                count <= 0;
        end else if (pulse) begin
                count <= count + 1'b1;
        end
end

endmodule

module PIPO1 (clk,resetPIPO1,pipo1_in,load1,pipo1_out);

input clk;
input resetPIPO1;
input [3:0] pipo1_in;
input load1;
output reg [3:0] pipo1_out;


always @(posedge clk)
begin
    if (resetPIPO1)
    begin
        pipo1_out <= 4'b0000;
    end
    else if (load1==1'b1)
    begin
        pipo1_out <= pipo1_in;
    end
end
endmodule

module mux1 (a,b,sel,mux1_out);
    input[3:0] a; //4bit input size
    input[4:0] b; //5bit input size
    input sel;  
    output reg[4:0] mux1_out;
   

    always @(*) begin
        case (sel)
            1'b0: mux1_out = {1'b0,a};
            1'b1: mux1_out = 5'b10000; 
            default: mux1_out = 0;
        endcase     
    end
endmodule

module counter(clk,resetRam,count_in,count_out);

input clk;
input resetRam;
input count_in;
output reg [9:0]count_out;
 
always @ (posedge clk) begin
 if (resetRam)
  count_out <= 0;
 else if (count_in)
  count_out <= count_out + 1;
end   

endmodule

module ram(clk,wr_en,resetRam,data_in,addr,data_out);
input clk;       //clock
input wr_en;         //write enable
input resetRam;
input [9:0] data_in;     //Input data.
input [4:0] addr;   //address
output [9:0] data_out; //output data

//memory declaration.
reg [9:0] ram [0:31];

always @(posedge clk) begin
    if (resetRam) begin
        for (integer i = 0; i < 32; i = i + 1) begin
            ram[i] <= {10{1'b0}};
        end
    end else if (wr_en) begin
        ram[addr] <= data_in;
    end
end

//always reading from the ram, irrespective of clock.
assign data_out =ram[addr];

endmodule

module demux12 (demux_in,selD,out1,out2);
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


module adder(adder_in,adder_out);

input [9:0]adder_in;
output reg [9:0]adder_out;

always @(*) begin
    adder_out= adder_in+1;
end

endmodule

module mux2 (x,y,sel,mux2_out);
    input[9:0] x;
    input[9:0] y;
    input sel;  
    output reg[9:0] mux2_out;
   

    always @(*) begin
        case (sel)
            1'b0: mux2_out = x;
            1'b1: mux2_out = y; 
            default: mux2_out = 0;
        endcase     
    end
endmodule


