module top#(
    parameter ANS1 = 8,
    parameter ANS2 = 0,
    parameter LED_ON_PERIOD = 300
)(
    input clk,
    input rst,

    input start,
    input done,

    input [9:0] button,
    output [1:0] led //led1 == Correct, led0 == Wrong
);
    localparam IDLE = 0,
        START = 1,
        IN1 = 2,
        ERR1 = 3,
        ERR_ANY = 4,
        ANY = 5,
        IN2 = 6,
        PASS = 7,
        FAIL = 8,
        PRINT_RES = 9;
    localparam IDX_SIZE = $clog2(LED_ON_PERIOD);
    reg [3:0] state;
    reg [3:0] next;

    reg [1:0] led_out;
    wire std;
    wire d;

    reg [IDX_SIZE - 1 : 0] led_cnt;

    reg led_valid;
    wire res_print_done;

    wire [9:0] btn;

    assign led = led_valid ? led_out : 2'b0;

    edge_dect start_button(
        .clk(clk),
        .rst(rst),
        .enable(start),
        .pos_edge(1'b1),
        .out(std)
    );

    edge_dect done_button(
        .clk(clk),
        .rst(rst),
        .enable(done),
        .pos_edge(1'b1),
        .out(d)
    );

    edge_dect button0(
        .clk(clk),
        .rst(rst),
        .enable(button[0]),
        .pos_edge(1'b1),
        .out(btn[0])
    );

    edge_dect button1(
        .clk(clk),
        .rst(rst),
        .enable(button[1]),
        .pos_edge(1'b1),
        .out(btn[1])
    );

    edge_dect button2(
        .clk(clk),
        .rst(rst),
        .enable(button[2]),
        .pos_edge(1'b1),
        .out(btn[2])
    );

    edge_dect button3(
        .clk(clk),
        .rst(rst),
        .enable(button[3]),
        .pos_edge(1'b1),
        .out(btn[3])
    );

    edge_dect button4(
        .clk(clk),
        .rst(rst),
        .enable(button[4]),
        .pos_edge(1'b1),
        .out(btn[4])
    );

    edge_dect button5(
        .clk(clk),
        .rst(rst),
        .enable(button[5]),
        .pos_edge(1'b1),
        .out(btn[5])
    );

    edge_dect button6(
        .clk(clk),
        .rst(rst),
        .enable(button[6]),
        .pos_edge(1'b1),
        .out(btn[6])
    );

    edge_dect button7(
        .clk(clk),
        .rst(rst),
        .enable(button[7]),
        .pos_edge(1'b1),
        .out(btn[7])
    );

    edge_dect button8(
        .clk(clk),
        .rst(rst),
        .enable(button[8]),
        .pos_edge(1'b1),
        .out(btn[8])
    );

    edge_dect button9(
        .clk(clk),
        .rst(rst),
        .enable(button[9]),
        .pos_edge(1'b1),
        .out(btn[9])
    );

    edge_dect print_result(
        .clk(clk),
        .rst(rst),
        .enable(led_valid),
        .pos_edge(1'b0),
        .out(res_print_done)
    );


    always @(posedge clk or negedge rst)begin
        if(!rst)state <= IDLE;
        else state <= next;
    end

    always @(state or std or d or btn)begin
        case(state)
            IDLE: begin
                led_out = 2'b00;
                next = std ? START : IDLE;
            end

            START: begin
                if(btn == (1 << ANS1)) next = IN1;
                else if((btn != (1 << ANS1)) && btn != 10'h0) next = ERR1;
                else next = START;
            end

            IN1 : next = (btn || 10'h0) ? ANY : IN1;
            ERR1 : next = (btn || 10'h0) ? ANY : ERR1;

            ANY : begin
                if(btn == (1 << ANS2)) next = PASS;
                else if((btn != (1 << ANS2)) && btn != 10'h0) next = FAIL;
                else next = ANY;
            end

            ERR_ANY : next = (btn || 10'h0) ? FAIL : ERR_ANY;

            PASS : begin 
                next = d ? PRINT_RES : PASS;
                led_out = 2'b10; //Right Answer
            end

            FAIL : begin
                next = d ? PRINT_RES : FAIL;
                led_out = 2'b01; //Wrong Answer
            end

            PRINT_RES : begin
                if (std) begin
                    led_out = 2'b00;
                    next = START;
                end
                else if (res_print_done) next = IDLE;
                else next = PRINT_RES;
            end
        endcase
    end

    always @(posedge clk or negedge rst)begin
        if(d) led_cnt <= 6'h0;
        case(state)
            PRINT_RES: begin
                if(led_cnt == LED_ON_PERIOD)begin
                    led_valid <= 1'b0;
                end
                else begin
                    led_valid <= 1'b1;
                    led_cnt <= led_cnt + 1'b1;
                end
            end

            default: begin
                led_valid <= 1'b0;
                led_cnt <= 6'h0;
            end
        endcase
    end         
endmodule