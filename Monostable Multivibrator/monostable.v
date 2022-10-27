
module monostable(
        input clk,
        input reset,
        input trigger,
        output reg pulse = 0
);
        parameter PULSE_WIDTH = 20;

        reg [4:0] count;

        always @(posedge clk, posedge reset) begin
                if (reset) begin
                        pulse <= 1'b0;
                end else if (trigger) begin
                        pulse <= 1'b1;
                end else if (count == PULSE_WIDTH-1) begin
                        pulse <= 1'b0;
                end
        end

        always @(posedge clk, posedge reset) begin
                if(reset) begin
                        count <= 0;
                end else if (pulse) begin
                        count <= count + 1'b1;
                end
        end
endmodule



module monostable_tb();

reg clk;
reg reset;
reg trigger;
wire pulse;

parameter PULSE_WIDTH = 20;


monostable imonostable(.*);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $monitor("trigger=%b  pulse=%b, count = %0d",trigger,pulse,imonostable.count);
    $dumpfile("monostable_tb.vcd");
    $dumpvars(0,monostable_tb);

    trigger<=1'b0;
    reset <= 1'b0;    

    @(posedge clk) reset  <= 1'b1;
    @(posedge clk) reset  <= 1'b0;  
    trigger<= 1'b1;
    #30;
    trigger<= 1'b0;
    #200;
    @(posedge clk) reset  <= 1'b1;
    @(posedge clk) reset  <= 1'b0; 
    trigger<= 1'b1;
    #15;
    trigger<= 1'b0;
    #350;

    $finish;
end  
endmodule

// cd C:\iverilog\Counter
//iverilog -o monostable_tb.vvp monostable.v
//vvp monostable_tb.vvp
//gtkwave 