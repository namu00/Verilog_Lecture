module add_shift_mul(
    input clk,
    input rst,

    input start,
    input [3:0] src1,
    input [3:0] src2,

    output [7:0] result,
    output valid

    // output [6:0] fnd4,
    // output [6:0] fnd3,
    // output [6:0] fnd2,
    // output [6:0] fnd1
);

    localparam IDLE = 0,
        LOAD = 1,
        PHASE1 = 2,
        PHASE2 = 3,
        PHASE3 = 4,
        PHASE4 = 5,
        VALID = 6;

    reg [3:0] A;
    reg [3:0] B;
    reg [7:0] product;
    reg start_d;

    reg valid_d1;
    reg valid_d2;

    reg [2:0] state;
    reg [2:0] next;

    wire start_edge;
    wire carry;
    wire [3:0]ha_res;

    assign start_edge = !start & start_d;
    assign valid = valid_d1 & !valid_d2;
    assign result = (state == VALID) ? product : 8'b0;

    ha u_halfadder(
        .src1   (product[7:4]),
        .src2   (A),
        .c_out  (carry),
        .result (ha_res)
    );

    // fnd u_fnd4(
    //     .number (src1),
    //     .fnd    (fnd4)
    // );

    // fnd u_fnd3(
    //     .number (src2),
    //     .fnd    (fnd3)
    // );

    // fnd u_fnd2(
    //     .number (product[7:4]),
    //     .fnd    (fnd2)
    // );

    // fnd u_fnd1(
    //     .number (product[3:0]),
    //     .fnd    (fnd1)
    // );

    always @(posedge clk or negedge rst)begin
        if(!rst) state <= IDLE;
        else state <= next;
    end

    always @(state or start_edge)begin
        case(state)
            IDLE: next = start_edge ? LOAD : IDLE;
            LOAD: next = PHASE1;
            PHASE1: next = PHASE2;
            PHASE2: next = PHASE3;
            PHASE3: next = PHASE4;
            PHASE4: next = VALID;
            VALID: next = start_edge ? LOAD : VALID;
            default : next = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            product <= 0;
            valid_d1 <= 0;
        end

        else begin
            case(state)
                IDLE:begin
                    A <= 0;
                    B <= 0;
                    product <= 0;
                    valid_d1 <= 0;
                end

                LOAD: begin
                    A <= src1;
                    B <= src2;
                    product <= {4'h0,src2};
                    valid_d1 <= 0;
                end

                PHASE1: begin
                    if(B[0]) begin
                        product <= {carry,ha_res,product[3:1]};
                    end

                    else product <= {1'b0, product[7:1]};
                end

                PHASE2: begin
                    if(B[1]) begin
                        product <= {carry,ha_res,product[3:1]};
                    end

                    else product <= {1'b0, product[7:1]};
                end

                PHASE3: begin
                    if(B[2]) begin
                        product <= {carry,ha_res,product[3:1]};
                    end

                    else product <= {1'b0, product[7:1]};
                end

                PHASE4: begin
                    if(B[3]) begin
                        product <= {carry,ha_res,product[3:1]};
                    end

                    else product <= {1'b0, product[7:1]};
                end

                VALID: valid_d1 <= 1;

                default: begin
                    A <= 0;
                    B <= 0;
                    product <= 0;
                    valid_d1 <= 0;
                end

            endcase
        end
    end

    //Edge_Detecting
    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            start_d <= 0;
            valid_d2 <= 0;
        end

        else begin
            start_d <= start;
            valid_d2 <= valid_d1;
        end
    end
endmodule