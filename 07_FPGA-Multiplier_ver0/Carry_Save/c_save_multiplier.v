module c_save_multiplier(
    input clk,
    input rst,

    input [3:0]src1,
    input [3:0]src2,
    input start,
    output [7:0] result,
    output valid
);

    reg [3:0] A;
    reg [3:0] B;
    
    reg start_d;
    reg valid_d1;
    reg valid_d2;
    reg [7:0] res;
    wire [16:0] and_res;
    wire [16:0] carry;
    wire start_edge;
    wire valid_edge;


    assign start_edge = !start & start_d; //Falling edge trigger
    assign valid_edge = valid_d1 & !valid_d2; //rising edge trigger
    assign valid = valid_edge;
    assign result = res;

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            A <= 0;
            B <= 0;
            valid_d1 <= 0;
        end

        else if(start_edge)begin
            A <= src1;
            B <= src2;
            valid_d1 <= 1;
        end

        else if(valid_edge) begin
            valid_d1 <= 0;
        end
    end

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            start_d <= 0;
            valid_d2 <= 0;
        end

        else begin
            start_d <= start;
            valid_d2 <= valid_d1;
        end
    end

    always @(A or B or and_res) begin
        res[0] = A[0] & B[0];   //M0
        res[1] = and_res[0];    //M1
        res[2] = and_res[4];    //M2
        res[3] = and_res[8];    //M3
        res[4] = and_res[12];   //M4
        res[5] = and_res[13];   //M5
        res[6] = and_res[14];   //M6
        res[7] = and_res[15];   //M7
    end

    //argument sequence: src1, src2, c_in, c_out, sum
    //sum array layer1
    fa layer10((B[0] & A[1]), (B[1] & A[0]), 1'b0, carry[0], and_res[0]);   //M1
    fa layer11((B[0] & A[2]), (B[1] & A[1]), 1'b0, carry[1], and_res[1]);  
    fa layer12((B[0] & A[3]), (B[1] & A[2]), 1'b0, carry[2], and_res[2]);
    fa layer13((1'b0), (B[1] & A[3]), 1'b0, carry[3], and_res[3]);

    //sum array layer2
    fa layer20(and_res[1], (B[2] & A[0]), carry[0], carry[4], and_res[4]);  //M2
    fa layer21(and_res[2], (B[2] & A[1]), carry[1],carry[5],and_res[5]);    
    fa layer22(and_res[3], (B[2] & A[2]), carry[2],carry[6],and_res[6]);
    fa layer23(carry[3], (B[2] & A[3]), 1'b0, carry[7],and_res[7]);

    //sum array layer3
    fa layer30(and_res[5], (B[3] & A[0]), carry[4], carry[8], and_res[8]);  //M3     
    fa layer31(and_res[6], (B[3] & A[1]), carry[5], carry[9], and_res[9]);
    fa layer32(and_res[7], (B[3] & A[2]), carry[6], carry[10],and_res[10]);
    fa layer33(carry[7], (B[3] & A[3]), 1'b0,carry[11],and_res[11]);        

    //sum array layer4
    fa layer40(carry[8], and_res[9], 1'b0, carry[12], and_res[12]);         //M4
    fa layer41(carry[9], and_res[10], carry[12], carry[13], and_res[13]);   //M5
    fa layer42(carry[10], and_res[11], carry[13], carry[14], and_res[14]);  //M6
    fa layer43(carry[11], carry[14], 1'b0, carry[15], and_res[15]);         //M7
endmodule