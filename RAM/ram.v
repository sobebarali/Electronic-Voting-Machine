module ram
    (   input clk,       //clock
        input wr_en,         //write enable
        input resetRam,
        input [9:0] data_in,     //Input data.
        input [4:0] addr,   //address
        output [9:0] data_out //output data
    );

//memory declaration.
reg [9:0] ram[0:15];

always @(posedge clk) begin
    if (resetRam) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            ram[i] <= {10{1'b0}};
        end
    end else if (wr_en) begin
        ram[addr] <= data_in;
    end
end

//always reading from the ram, irrespective of clock.
assign data_out = !wr_en ? ram[addr] : 'h0;

endmodule 

module ram_tb;

    // Inputs
    reg clk;
    reg wr_en;
    reg resetRam;
    wire [9:0] data_in;
    reg [4:0] addr;
    
    // Outputs
    wire [9:0] data_out;

    reg [9:0] tb_data;
    
    integer i;

   
    ram iram(.*);
    
    assign data_in = wr_en ? tb_data : 'h0 ;

    always
        #5 clk = ~clk;

    initial begin
        $monitor("addrs = %b resetRam=%b Write = %b  dataIn = %b dataOut = %b", addr,resetRam,wr_en,data_in,data_out);
        $dumpfile("ram_tb.vcd");
        $dumpvars(0,ram_tb);
        // Initialize Inputs
        clk <= 0;
        addr <= 0;
        wr_en <= 0;
        resetRam <= 0;
        tb_data <= 0;  
        #20;

        //Write all the locations of RAM  
        wr_en <= 1;
      for(i=1; i <= 16; i = i + 1) begin
            tb_data <= i;
            addr <= i-1;
            #10;
        end
        wr_en <= 0;

        //Read from  all the locations of RAM.
        for(i=1; i <= 16; i = i + 1) begin
            addr <= i-1;
            #10;
        end

        //resetRam
        resetRam <= 1;
        #10;
        resetRam <= 0;
        #10;

        //Read from  all the locations of RAM.
        for(i=1; i <= 16; i = i + 1) begin
            addr <= i-1;
            #10;
        end


        

    #100
    $finish;
    end
       
endmodule

//iverilog -o ram_tb.vpp ram.v
//vvp ram_tb.vpp