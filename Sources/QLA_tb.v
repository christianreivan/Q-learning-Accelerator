module reward_generator_tb ();
    reg clk;
    reg [3:0] step;
    reg [4:0] next_state;
    wire [31:0] reward;

    reward_generator rg (clk, next_state, step, reward);

    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        step = 4'd1; next_state = 5'd1;

        #300
        step = 4'd3; next_state = 5'd5;
        
        #300
        step = 4'd10; next_state = 5'd17;

        #300
        step = 4'd15; next_state = 5'd24;
        
        #300
        step = 4'd8; next_state = 5'd25;
    end
endmodule

module Q_updater_tb ();
    reg clk;
    reg signed [31:0] Q_sa, Q_max, reward;
    wire signed [31:0] Q_new;

    Q_updater tb(.Q_sa(Q_sa), .Q_max(Q_max), .reward(reward), .Q_new(Q_new));

    initial 
    begin 
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        Q_sa = 32'd0; Q_max = 32'd0; reward = 32'd0;
        #100 Q_sa = 32'd0; Q_max = 32'd0; reward = -32'd50;
        #100 Q_sa = 32'd0; Q_max = 32'd0; reward = 32'd100;
        #100 Q_sa = -32'd25; Q_max = 32'd0; reward = 32'd100;
        #100 Q_sa = -32'd33; Q_max = -32'd25; reward = 32'd0;
    end
endmodule

module ram_tb ();
    reg clk, rst, wr_en1;
    reg [4:0] wr_addr, rd_addr;
    reg [31:0] data_in;
    wire [31:0] data_out1;

    ram1 tb(clk, wr_addr, data_in, rd_addr, wr_en1, data_out1);

    initial 
    begin 
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 0;
        data_in = 31'd1;
        wr_addr = 4'd0;
        wr_en1 = 1'b1;

        #100
        data_in = 31'd2;
        wr_addr = 4'd1;
        wr_en1 = 1'b1;
        rd_addr = 4'd0;

        #100
        data_in = 31'd3;
        wr_addr = 4'd2;
        wr_en1 = 1'b1;
        rd_addr = 4'd1;

        #100
        wr_en1= 1'b0;
        rd_addr = 4'd0;

        #100
        rd_addr = 4'd1;

        #100
        rd_addr = 4'd2;
        
        #100
        rd_addr = 4'd1;

        #100
        rd_addr = 4'd0;

    end
endmodule

module QLA_tb ();
    reg clk, rst, decoder_en;
    reg [1:0] act;
    reg [3:0] step;
    reg [4:0] current_state, next_state;
    wire [31:0] Q_max, Qnext_0, Qnext_1, Qnext_2, Qnext_3;

    QLA QLearningAccelerator (clk, rst, decoder_en, current_state
                            , step, next_state, act, Q_max
                            , Qnext_0, Qnext_1, Qnext_2, Qnext_3);
    
    initial begin
        clk = 1'b1;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1; act = 2'b11; decoder_en = 0; step = 4'd0; current_state = 5'd1; next_state = 5'd6;

        #500
        rst = 0; act = 2'b00; decoder_en = 0; step = 4'd1; current_state = 5'd1; next_state = 5'd6;

        #500
        rst = 0; act = 2'b01; decoder_en = 1; step = 4'd2; current_state = 5'd6; next_state = 5'd17;
        
        #500
        rst = 0; act = 2'b10; decoder_en = 1; step = 4'd3; current_state = 5'd11; next_state = 5'd25;
    end
endmodule