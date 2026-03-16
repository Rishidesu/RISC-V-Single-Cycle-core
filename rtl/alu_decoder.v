module alu_decoder(aluop,funct3,funct7,op5,ALUcontrol);

input op5,funct7;
input [2:0] funct3;
input [1:0] aluop;
output [2:0] ALUcontrol;

wire [1:0] concate;

assign concate = {op5,funct7};

assign ALUcontrol =
        (aluop==2'b00) ? 3'b000 :
        (aluop==2'b01) ? 3'b001 :
        ((aluop==2'b10)&&(funct3==3'b010)) ? 3'b101 :
        ((aluop==2'b10)&&(funct3==3'b110)) ? 3'b011 :
        ((aluop==2'b10)&&(funct3==3'b111)) ? 3'b010 :
        ((aluop==2'b10)&&(funct3==3'b000)&&(concate==2'b11)) ? 3'b001 :
        ((aluop==2'b10)&&(funct3==3'b000)&&(concate!=2'b11)) ? 3'b000 :
        3'b000;

endmodule
