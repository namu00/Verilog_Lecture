module mux4by1_hw1(din0_hw1, din1_hw1, sel, dout_hw1);
    input [2:0] din0_hw1;
    input [2:0] din1_hw1;
    input [1:0] sel;
    output [2:0] dout_hw1;
    
    reg [2:0] out;

    always@(din0_hw1 or din1_hw1 or sel)begin
        out <= (sel == 2'h0) ? din0_hw1 + din1_hw1 :
                (sel == 2'h1) ? din0_hw1 + (~(din1_hw1)+3'b001) :
                (sel == 2'h2) ? din0_hw1 & din1_hw1 :
                {1'b0,din0_hw1[1:0]};
    end
    assign dout_hw1 = out;
endmodule