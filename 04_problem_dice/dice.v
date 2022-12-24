module dice(
    input clk,
    input rst,
    input start,
    input coin,
    output [1:0] out
);

    parameter NONE = 2'b00;
    parameter RED = 2'b01;
    parameter BLUE = 2'b10;

    parameter IDLE = 4'd0;
    parameter ZERO = 4'd1;
    parameter ONE = 4'd2;
    parameter A = 4'd3;
    parameter B = 4'd4;
    parameter C = 4'd5;
    parameter D = 4'd6;
    parameter E = 4'd7;
    parameter F = 4'd8;
    parameter G = 4'd9;
    parameter H = 4'd10;
    parameter I = 4'd11;
    parameter J = 4'd12;
    parameter K = 4'd13;
    parameter L = 4'd14;

    reg [3:0] state;
    reg [3:0] next;
    reg [1:0] color; 
    reg start_flag; //For Debuging
    assign out = color;

    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            state <= IDLE;
        end
        else begin
            if(start == 1'b1)begin 
                state <= IDLE;
            end
            else begin
                state <= next;
            end
        end
    end

    always@(coin or state)begin
        case(state)
            IDLE : next = coin ? ONE : ZERO;

            ZERO: next = coin ? B : A;
            A: next = coin ? C : D;
            B: next = coin ? E : F;

            ONE: next = coin ? H : G;
            G: next = coin ? I : J;
            H: next = coin ? K : L;

            default: next = IDLE;
        endcase
    end

    always@(posedge clk or negedge rst) begin
        case(state)
            IDLE: color <= NONE;

            ZERO: color <= NONE;
            ONE: color <= NONE;

            A: color <= NONE;
            B: color <= NONE;
            C: color <= RED;
            D: color <= NONE;
            E: color <= BLUE;
            F: color <= NONE;

            G: color <= NONE;
            H: color <= NONE;
            I: color <= NONE;
            J: color <= BLUE;
            K: color <= NONE;
            L: color <= RED;

            default: color <= NONE;
        endcase
    end
    
endmodule