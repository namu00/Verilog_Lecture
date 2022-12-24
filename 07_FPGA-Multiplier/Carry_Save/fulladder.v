module fa(
    input src1,
    input src2,
    input c_in,

    output c_out,
    output sum
);
    assign {c_out,sum} = src1 + src2 + c_in;
endmodule