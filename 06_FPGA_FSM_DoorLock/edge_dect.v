module edge_dect(
    input clk,
    input rst,
    input enable,
    input pos_edge,
    output out
);
    reg _out;

    assign out = pos_edge ? enable && (~_out) : ~enable && _out;

    always @(posedge clk or negedge rst)begin
        if(!rst) _out <= 1'b0;
        else _out <= enable;
    end
endmodule