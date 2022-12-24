module ha(
    input [3:0] src1,
    input [3:0] src2,
    output [3:0] result,
    output c_out
);

    assign {c_out,result} = src1 + src2;
endmodule