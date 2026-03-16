module data_memory(clk,rst,A,wd,we,rd);
    input [31:0] A,wd;
    output [31:0] rd;
    input clk,rst,we;
    
    reg [31:0] data_memorys [1023:0];

    assign rd=((we==1'b0)&(rst==1'b1))? data_memorys[A]:32'h00000000;

    always@(posedge clk)
    begin
        if(we==1'b1)
        begin
            data_memorys[A]<=wd;
        end
    end
    initial begin
        data_memorys[28]=32'h00000020;
    end




endmodule
