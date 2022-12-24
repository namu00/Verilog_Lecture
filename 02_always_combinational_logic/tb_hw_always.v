`timescale 1ns/100ps

module tb_hw_always();
    reg [2:0] din0;
    reg [2:0] din1;
    reg [1:0] sel;

    wire [2:0] dout1;
    wire [2:0] dout2;
    wire [2:0] dout3;

    mux4by1_hw1 mux_unit_0(
        .din0_hw1(din0),
        .din1_hw1(din1),
        .sel(sel),
        .dout_hw1(dout1)
    );

    mux4by1_hw2 mux_unit_1(
        .din0_hw2(din0),
        .din1_hw2(din1),
        .sel(sel),
        .dout_hw2(dout2)
    );

    mux4by1_hw3 mux_unit_2(
        .din0_hw3(din0),
        .din1_hw3(din1),
        .sel(sel),
        .dout_hw3(dout3)
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