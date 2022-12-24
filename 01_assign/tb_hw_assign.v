`timescale 1ns/100ps

module tb_hw_assign();
    reg [2:0] din0;
    reg [2:0] din1;
    reg [1:0] sel;

    wire [2:0] dout;

    mux4by1 mux_unit_0(
        .din0(din0),
        .din1(din1),
        .sel(sel),
        .dout(dout)
    );

    initial begin
        din0 = 3'h2;
        din1 = 3'h1;
        sel = 2'h0;
        #(10) sel = 2'h1;
        #(10) sel = 2'h2;
        #(10) sel = 2'h3;
        #(10)

        din0 = 3'h3;
        din1 = -3'h2;
        sel = 2'h0;
        #(10) sel = 2'h1;
        #(10) sel = 2'h2;
        #(10) sel = 2'h3;
        #(10) $stop;
    end
endmodule