`timescale 1ns/1ps
module vending_machine_tb;
wire dispense,change;
reg clk,rst,coin5,coin10;
vending_machine dut(.dispense(dispense),.change(change),.clk(clk),.rst(rst),.coin5(coin5),.coin10(coin10));
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
coin5=0;
coin10=0;
#10 rst=0;
//testcase1:5+10
#10 coin5=1;
#10 coin5=0;
coin10=1;
#10 coin10=0;
#10;
//testcase2:10+10
#10 coin10=1;
#10 coin10=0;
#10 coin10=1;
#10 coin10=0;
#20;
//testcase3:no sufficient memory
#10 coin5=1;
#10 coin5=0;
#20;
$finish;
end
initial begin
$monitor("Time=%0t Coin5=%b coin10=%b Dispense=%b Change=%b",$time,coin5,coin10,dispense,change);
$fsdbDumpfile("vending_machine.fsdb");
$fsdbDumpvars(0,vending_machine_tb);
$dumpfile("vending_machine.vcd");
$dumpvars(0,vending_machine_tb);
end
endmodule
