module CU_tb ();
    reg clk, rst;
    reg [11:0] total_iteration_in;
    wire change_iteration, done;
    wire [3:0] step;
    wire [11:0] total_iteration, iteration;

    CU control(clk, rst, change_iteration, done
            , total_iteration_in, step, total_iteration
            , iteration);

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1;
        total_iteration_in = 12'd300;

        #300
        rst = 0;
    end
endmodule 