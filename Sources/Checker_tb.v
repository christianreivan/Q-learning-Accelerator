module checker_tb();
    reg clk, rst, change_iteration;
    reg [1:0] act; 
    wire [4:0] curr_state, next_state;
    wire decoder_en;

    checker check(clk, rst, change_iteration, act
                , curr_state, next_state, decoder_en);
    
    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1;
        change_iteration = 0;
        act = 2'd3;
        
        
        #300
        

        #100
        rst = 0;
        change_iteration = 0;
        act = 2'd3; //next_state = 6

        #100
        change_iteration = 0;
        act = 2'd3; //next_state = 11

        #100
        change_iteration = 0;
        act = 2'd3; //next_state = 16

        #100
        change_iteration = 0;
        act = 2'd0; //next_state = 17

        #100
        change_iteration = 0;
        act = 2'd1; //next_state = 12

        #100
        change_iteration = 0;
        act = 2'd1; //next_state = 7

        #100
        change_iteration = 0;
        act = 2'd1; //next_state = 2

        #100
        change_iteration = 0;
        act = 2'd1; //next_state = 2

        #100
        change_iteration = 1;
        act = 2'd3; //next_state = 1

        #100
        change_iteration = 0;
        act = 2'd3; //next_state = 6
    end
endmodule