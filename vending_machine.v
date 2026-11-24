`timescale 1ns/1ps
module vending_machine(output reg dispense,change ,input clk,rst,coin5,coin10);
parameter s0=3'b000,
	  s5=3'b001,
	  s10=3'b010,
	  s15=3'b011,
	  s20=3'b100;
reg [2:0] state,next_state;
always @(posedge clk or posedge rst) begin
	if(rst)
	   state<=s0;
	else 
	   state<=next_state;
	end
always @(state or coin5 or coin10) begin
	next_state=state;
	case(state)
	  s0:begin
	    if(coin5)
		next_state=s5;
	    else if(coin10)
		next_state=s10;
	     end
	  s5:begin
	    if(coin5)
	        next_state=s10;
            else if(coin10)
		next_state=s15;
	     end	
	  s10:begin
	   if(coin5)
		next_state=s15;
	   else if(coin10)
		next_state=s20;
	       end	
	  s15,s20:begin
	   next_state=s0;
           end
          default:
	   next_state=s0;
   endcase
end
always @(state) begin
 dispense=0;
 change=0;
 case(state)
    s15:dispense=1;
    s20:begin
       dispense=1;
       change=1;
       end
    endcase
 end
endmodule
