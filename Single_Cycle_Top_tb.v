module Single_Cycle_Top_tb;

reg clk;
reg rst;

Single_Cycle_Top Single_Cycle_Top (
.clk(clk),
.rst(rst)
);

// waveform dump
initial begin
$dumpfile("single_cycle.vcd");
$dumpvars(0, Single_Cycle_Top_tb);
end

// clock generation (100 time units period)
initial begin
clk = 0;
forever #50 clk = ~clk;
end

// reset sequence
initial begin
rst = 0;
#100;
rst = 1;


#300;
$finish;


end

endmodule
