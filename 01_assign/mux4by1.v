module mux4by1(din0, din1, sel, dout);
    input [2:0] din0;
    input [2:0] din1;
    input [1:0] sel;
    output [2:0] dout;

    assign dout = (sel == 3'b00) ? din0 + din1 :
                  (sel == 3'b01) ? din0 + ((~din1) + 3'b001): //Two's Compliment Substraction
                  (sel == 3'b10) ? din0 & din1:
                  {1'b0, din0[2:1]};
endmodule
