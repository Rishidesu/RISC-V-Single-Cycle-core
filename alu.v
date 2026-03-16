module alu(
    input [31:0] A,B,
    input [2:0] ALUcontrol,
    output [31:0] final_result,
    output zero,c,v,n
);

wire [31:0] result;
wire [31:0] a_or_b,a_and_b,not_b;
wire [31:0] mux_1;
wire [31:0] sum;
wire carry;
wire [31:0] slt;
wire overflow;

assign not_b = ~B;
assign mux_1 = ALUcontrol[0] ? not_b : B;

assign a_or_b = A | B;
assign a_and_b = A & B;

assign {carry,sum} = A + mux_1 + ALUcontrol[0];

assign overflow = (A[31]^sum[31]) & (mux_1[31]^sum[31]);
assign slt = {31'b0,(sum[31]^overflow)};

assign result =
        (ALUcontrol==3'b000) ? sum :
        (ALUcontrol==3'b001) ? sum :
        (ALUcontrol==3'b010) ? a_and_b :
        (ALUcontrol==3'b011) ? a_or_b :
        (ALUcontrol==3'b101) ? slt :
        32'b0;

assign final_result = result;
assign zero = (result==0);
assign c = carry;
assign v = overflow;
assign n = result[31];

endmodule