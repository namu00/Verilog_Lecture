module mux4by1_hw2(din0_hw2, din1_hw2, sel, dout_hw2);
    input [2:0] din0_hw2;
    input [2:0] din1_hw2;
    input [1:0] sel;
    output [2:0] dout_hw2;
    
    reg [2:0] out;

    always@(din0_hw2 or din1_hw2 or sel)begin
        if (sel == 2'h0) out <= din0_hw2 + din1_hw2;
        else if (sel == 2'h1) out <= din0_hw2 + (~(din1_hw2)+1'b1) ;
        else if (sel == 2'h2) out <= din0_hw2 & din1_hw2;
        else if (sel == 2'h3) out <= {1'b0,din0_hw2[2:1]};
        else out <= 3'b0;
    end
    assign dout_hw2 = out;
endmodule