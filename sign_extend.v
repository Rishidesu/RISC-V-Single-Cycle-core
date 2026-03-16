module sign_extend(in, imm_extend);

input  [31:0] in;
output [31:0] imm_extend;

assign imm_extend = (in[31]) ? {{20{1'b1}}, in[31:20]} :
                               {{20{1'b0}}, in[31:20]};

endmodule