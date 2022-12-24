module testbench();
    //인스턴스를 위한 변수 선언부 시작
    reg clk;
    reg rst;
    reg start;
    reg done;

    reg [9:0] button;
    wire [1:0] led;
    
    parameter ANS1 = 8;
    parameter ANS2 = 0;
    parameter LED_ON_PERIOD = 300;
    //인스턴스를 위한 변수 선언부 끝

    //모듈 인스턴스 시작
    top #(
        .ANS1(ANS1),
        .ANS2(ANS2),
        .LED_ON_PERIOD(LED_ON_PERIOD)
    )t_top(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .button(button),
        .led(led)
    );
    //모듈 인스턴스 끝
    task door_lock;
        input [9:0] in1;
        input [9:0] in2;
        input [9:0] in3;
        begin
            start = 1'b1;
            repeat(5) @(posedge clk);
            start = 1'b0;
            repeat(5) @(posedge clk);
            
            repeat(5) @(posedge clk);
            button = (1 << in1);
            repeat(5) @(posedge clk);
            button = 0;
            
            repeat(5) @(posedge clk);
            button = (1 << in2);
            repeat(5) @(posedge clk);
            button = 0;

            repeat(5) @(posedge clk);
            button = (1 << in3);
            repeat(5) @(posedge clk);
            button = 0;

            repeat(5) @(posedge clk);
            done = 1'b1;
            repeat(5) @(posedge clk);
            done = 1'b0;

            repeat(LED_ON_PERIOD) @(posedge clk);
        end
    endtask

    initial begin
        button = 0;
        rst = 1'b0;
        start = 1'b0;
        done = 1'b0;
        clk = 1'b0;
        #13; rst = 1'b1;
    end

    always #5 clk = ~clk;

    initial begin
        wait(rst) repeat(10) @(posedge clk);
        //Write Answer
        door_lock(8,4,0);
        door_lock(8,7,0);

        //Wrong Answer
        door_lock(1,4,3);
        door_lock(8,5,8);
        door_lock(7,4,2);
        
        repeat(30) @(posedge clk);
        $stop;
    end
endmodule