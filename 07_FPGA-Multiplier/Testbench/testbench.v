module testbench();
    reg clk;
    reg rst;
    reg [3:0]src1;
    reg [3:0]src2;
    reg start;
    wire [7:0] result;
    wire valid;

    //TEST PASSED
    // array_multiplier u_array_mul(
    //     .clk(clk),
    //     .rst(rst),
    //     .src1(src1),
    //     .src2(src2),
    //     .start(start),
    //     .result(result),
    //     .valid(valid)
    // );
    //TEST PASSED

    //TEST PASSED
    carry_save_multiplier u_c_save_mul(
        .clk(clk),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .start(start),
        .result(result),
        .valid(valid)
    );
    //TEST PASSED

    integer i,k, err_cnt;
    task mul_test;
        input [3:0] A;
        input [3:0] B;
        input [7:0] ans;
        begin
            src1 = A;
            src2 = B;
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            wait(valid) @(posedge clk);
            if(result != ans) begin
                $display("%d Except, %d Received, Status: [FAILED]", ans, result);
                err_cnt = err_cnt + 1;
            end 
        end
    endtask


    initial begin
        clk = 0;
        rst = 0;
        start = 1;
        err_cnt = 0;
        #13 rst = 1;
    end

    always #5 clk = ~clk;

    
    initial begin
        wait(rst) @(posedge clk);
        for(i = 0; i < 4'hf; i = i + 1)begin
            for(k = 0; k < 4'hf; k = k + 1)begin
                mul_test(i,k,(i*k));
            end
        end

        //$display("Array_Multiplier Error Case: %d / %d",err_cnt, (16*16));
        $display("Carry_Save_Multiplier Error Case: %d / %d",err_cnt, (16*16));
        $stop;
    end
endmodule