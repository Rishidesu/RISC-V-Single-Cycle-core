module cu(
    zero,
    op,
    funct3,
    funct7,
    resultsrc,
    memwrite,
    alusrc,
    immsrc,
    regwrite,
    alucontrol,
    branch
);

input zero;
input [6:0] op;
input [2:0] funct3;
input funct7;

output branch,resultsrc,memwrite,alusrc,regwrite;
output [1:0] immsrc;
output [2:0] alucontrol;

wire [1:0] aluop;

main_decoder md(
    .zero(zero),
    .op(op),
    .branch(branch),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite),
    .aluop(aluop)
);

alu_decoder ad(
    .aluop(aluop),
    .funct3(funct3),
    .funct7(funct7),
    .op5(op[5]),
    .ALUcontrol(alucontrol)
);

endmodule
