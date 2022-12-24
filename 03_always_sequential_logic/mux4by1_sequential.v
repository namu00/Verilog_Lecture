module mux4by1_sequential(
    input clk,
    input rst,
    input [2:0] din0,
    input [2:0] din1,
    input [1:0] sel,
    output [2:0] dout);

    reg [2:0] res;

    always@(posedge clk or negedge rst)begin
        if(!rst) res <= 3'b0;
        else begin
            case(sel)
                2'b00: res <= din0 + din1;
                2'b01: res <= din0 + ((~din1) + 3'b001);
                2'b10: res <= din0 & din1;
                2'b11: res <= {1'b0,din0[2:1]};
                default : res <= 2'b0;
            endcase
        end
    end

    assign dout = res;
endmodule
