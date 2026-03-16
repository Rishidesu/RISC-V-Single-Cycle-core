module main_decoder(zero,op,branch,resultsrc,memwrite,alusrc,immsrc,regwrite,aluop);

input zero;
input [6:0] op;

output branch,resultsrc,memwrite,alusrc,regwrite;
output [1:0] immsrc,aluop;

assign regwrite = ((op==7'b0000011)||(op==7'b0110011));
assign memwrite = (op==7'b0100011);
assign resultsrc = (op==7'b0000011);

assign alusrc = ((op==7'b0000011)||(op==7'b0100011));

assign branch = (op==7'b1100011);

assign immsrc =
        (op==7'b0100011) ? 2'b01 :
        (op==7'b1100011) ? 2'b10 :
        2'b00;

assign aluop =
        (op==7'b1100011) ? 2'b01 :
        (op==7'b0110011) ? 2'b10 :
        2'b00;

endmodule
