module p_c(pcnext,pc,rst,clk);

input [31:0] pcnext;
input rst,clk;

output reg [31:0] pc;

always @(posedge clk)
begin
    if(rst==1'b0)
        pc <= 32'b0;
    else
        pc <= pcnext;
end

endmodule
