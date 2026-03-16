
module Single_Cycle_Top(clk,rst);
input clk,rst;
wire [31:0] pc_top,rd_instruction,rd1_top,rd2_top,imm_ext_top;
wire [31:0] alu_result,rd_data_memory_top,pc_plus4;
wire reg_write_top,zero_top,memwrite_top;
wire [2:0] alu_control_top;
p_c p_c1(
    .clk(clk),
    .rst(rst),
    .pc(pc_top),
    .pcnext(pc_plus4)
);

pc_adder pc_adder1(
    .a(pc_top),
    .b(32'd4),
    .c(pc_plus4)
);

instruction_memory instruction_memory1(
    .rst(rst),
    .A(pc_top),
    .RD(rd_instruction)
);

register_file register_file1(
    .clk(clk),
    .rst(rst),
    .we3(reg_write_top),
    .a1(rd_instruction[19:15]),
    .a2(rd_instruction[24:20]),
    .a3(rd_instruction[11:7]),
    .wd3(rd_data_memory_top),
    .rd1(rd1_top),
    .rd2(rd2_top)
);

sign_extend sign_extend1(
    .in(rd_instruction),
    .imm_extend(imm_ext_top)
);

alu alu1(
    .A(rd1_top),
    .B(imm_ext_top),
    .final_result(alu_result),
    .ALUcontrol(alu_control_top),
    .zero(zero_top),
    .c(),
    .v(),
    .n()
);

cu cu(
    .zero(zero_top),
    .op(rd_instruction[6:0]),
    .funct3(rd_instruction[14:12]),
    .funct7(rd_instruction[30]),
    .branch(),
    .resultsrc(),
    .memwrite(memwrite_top),
    .alusrc(),
    .immsrc(),
    .regwrite(reg_write_top),
    .alucontrol(alu_control_top)
);

data_memory data_memory(
    .A(alu_result),
    .wd(rd2_top),
    .we(memwrite_top),
    .rd(rd_data_memory_top),
    .clk(clk),
    .rst(rst)
);

endmodule
