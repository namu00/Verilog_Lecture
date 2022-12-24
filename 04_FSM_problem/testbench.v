module testbench();
    reg clk;
    reg rst;
    reg start;
    reg coin;
    wire [1:0] color;

    parameter RED = 2'b01;
    parameter BLUE = 2'b10;
    parameter NONE = 2'b00;

    dice test_unit0(.clk(clk),
        .rst(rst),
        .start(start),
        .coin(coin),
        .out(color)
    );
    integer i;
    initial begin
        clk = 1'b0; rst = 1'b0;
        start = 1'b0;
        coin = 1'b0;
        #13; rst = 1'b1;

        for(i = 0; i <9; i = i + 1)begin
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            repeat(4) @(posedge clk);
        end
        $stop;
    end

    always #5 clk = ~clk;
    initial begin
        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b0;
        $display("coin: 0 0 0");
        
        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b1;
        $display("coin: 0 0 1");
        
        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b0;
        $display("coin: 0 1 0");

        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b1;
        $display("coin: 0 1 1");
        
        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b0;
        $display("coin: 1 0 0");

        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b0;
        @(negedge clk); coin = 1'b1;
        $display("coin: 1 0 1");

        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b0;
        $display("coin: 1 1 0");

        wait(start); coin = 1'b0; 
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b1;
        @(negedge clk); coin = 1'b1;
        $display("coin: 1 1 1");
    end
endmodule