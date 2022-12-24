module testbench();
    reg clk;
    reg rst;

    reg start;
    reg [3:0]src1;
    reg [3:0]src2;

    wire [7:0] result;
    wire valid;

    add_shift_mul u_add_shift_mul(
        .clk    (clk),
        .rst    (rst),

        .start  (start),
        .src1   (src1),
        .src2   (src2),

        .result (result),
        .valid  (valid)
    );

    integer i,k, err_cnt;
    task mul_test;
        input [3:0] A;
        input [3:0] B;
        input [7:0] ans;
        begin
            src1 = A;
            src2 = B;
            @(negedge clk); start = 1'b1;
            repeat(1) @(posedge clk); start = 1'b0;
            if(valid == 1) begin
                if(result != ans) begin
                    $display("%d Except, %d Received, Status: [FAILED]", ans, result);
                    err_cnt = err_cnt + 1;
                end 
            end
            wait(valid) @(negedge clk);
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
        $display("Add_Save_Multiplier Error Case: %d / %d",err_cnt, (16*16));
        $stop;
    end
endmodule