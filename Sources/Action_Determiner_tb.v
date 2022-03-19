module action_determiner_tb ();
    reg clk;
    reg [11:0] iteration, total_iteration;
    reg [31:0] Q_max, in0, in1, in2, in3;
    wire [1:0] act;
    
    action_determiner tb(  clk, iteration, total_iteration,
                            Q_max, in0, in1, in2, in3, act);

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        iteration = 12'b0;
        forever #100 iteration = iteration + 1;
    end
    
    initial begin
        total_iteration = 12'd300; 
        Q_max = 32'd0;
        in0 = -32'd50; 
        in1 = -32'd20; 
        in2 = -32'd10; 
        in3 = 32'd0;

        #300
        total_iteration = 12'd300; 
        Q_max = 32'd0;
        in0 = -32'd25; 
        in1 = -32'd37; 
        in2 = 32'd0; 
        in3 = -32'd15;

        #300
        total_iteration = 12'd300; 
        Q_max = 32'd50;
        in0 = 32'd50; 
        in1 = -32'd20; 
        in2 = -32'd10; 
        in3 = 32'd0;

        #300
        total_iteration = 12'd300; 
        Q_max = 32'd50;
        in0 = 32'd00; 
        in1 = 32'd50; 
        in2 = -32'd30; 
        in3 = 32'd20;
    end
    
endmodule