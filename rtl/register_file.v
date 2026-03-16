module register_file(a1,a2,a3,clk,rst,we3,wd3,rd1,rd2);
    input clk,rst,we3;
    input [31:0] wd3;
    output [31:0] rd1,rd2;
    input [4:0] a1,a2,a3;
    reg [31:0] registers[31:0];

    assign rd1=(rst==1'b0)? 32'h00000000:registers[a1];
    assign rd2=(rst==1'b0)? 32'h00000000:registers[a2];
    initial begin
        registers[9]=32'h00000020;
    end
    always@(posedge clk)
    begin
        if(we3==1'b1)
        begin
            registers[a3]<=wd3;
        end 
    end
endmodule
