module encoder16to4 (encoder_in,valid,encoder_out);

input [15:0]encoder_in;
output reg valid;
output reg [3:0] encoder_out;


// 0000 --- 0000
// 0001 --- 0001
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