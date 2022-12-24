module mux4by1_hw3(din0_hw3, din1_hw3, sel, dout_hw3);
    input [2:0] din0_hw3;
    input [2:0] din1_hw3;
    input [1:0] sel;
    output [2:0] dout_hw3;
    
    reg [2:0] out;

    always@(din0_hw3 or din1_hw3 or sel)begin
        case(sel)
            2'h0 : out = din0_hw3 + din1_hw3 ;
            2'h1 : out = din0_hw3 + (~(din1_hw3)+3'b001);
            2'h2 : out = din0_hw3 & din1_hw3;
            2'h3 : out = {1'b0,din0_hw3[2:1]};
            default : out = 3'b0;
        endcase
    end
    assign dout_hw3 = out;
endmodule