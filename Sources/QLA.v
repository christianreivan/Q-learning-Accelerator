module maxQ (Q0, Q1, Q2, Q3, Q_max);
    input signed [31:0] Q0, Q1, Q2, Q3;
    output signed [31:0] Q_max;

    wire signed [31:0] wire1, wire2;

    assign wire1 = (Q0 > Q1)? Q0 : Q1;
    assign wire2 = (Q2 > Q3)? Q2 : Q3;
    assign Q_max = (wire1 > wire2)? wire1 : wire2;
endmodule


module mux4 (act, Q0, Q1, Q2, Q3, Q_sa);
    input [1:0] act;
    input [31:0] Q0, Q1, Q2, Q3;
    output [31:0] Q_sa;

    assign Q_sa = act[1] ? (act[0] ? Q3 : Q2) : (act[0] ? Q1 : Q0);
endmodule

module ram0 (clk, wr_addr, data_in, rd_addr, wr_en0, data_out0);
    input clk, wr_en0;
    input [4:0] wr_addr, rd_addr; //s1 to s25
    input [31:0] data_in;
    output [31:0] data_out0;

    //ram variable declaration
    reg [31:0] memory [0:25];

    initial begin
        $readmemh("ram0.txt", memory);
    end

    always @(posedge clk ) begin
        if (wr_en0) begin
            memory[wr_addr] = data_in;
        end
    end

    assign data_out0 = memory[rd_addr];
endmodule

module ram1 (clk, wr_addr, data_in, rd_addr, wr_en1, data_out1);
    input clk, wr_en1;
    input [4:0] wr_addr, rd_addr; //s1 to s25
    input [31:0] data_in;
    output [31:0] data_out1;

    //ram variable declaration
    reg [31:0] memory [0:25];

    initial begin
        $readmemh("ram1.txt", memory);
    end

    always @(posedge clk ) begin
        if (wr_en1) begin
            memory[wr_addr] = data_in;
        end
    end

    assign data_out1 = memory[rd_addr];
endmodule

module ram2 (clk, wr_addr, data_in, rd_addr, wr_en2, data_out2);
    input clk, wr_en2;
    input [4:0] wr_addr, rd_addr; //s1 to s25
    input [31:0] data_in;
    output [31:0] data_out2;

    //ram variable declaration
    reg [31:0] memory [0:25];

    initial begin
        $readmemh("ram2.txt", memory);
    end

    always @(posedge clk ) begin
        if (wr_en2) begin
            memory[wr_addr] = data_in;
        end
    end

    assign data_out2 = memory[rd_addr];
endmodule

module ram3 (clk, wr_addr, data_in, rd_addr, wr_en3, data_out3);
    input clk, wr_en3;
    input [4:0] wr_addr, rd_addr; //s1 to s25
    input [31:0] data_in;
    output [31:0] data_out3;

    //ram variable declaration
    reg [31:0] memory [0:25];

    initial begin
        $readmemh("ram3.txt", memory);
    end

    always @(posedge clk ) begin
        if (wr_en3) begin
            memory[wr_addr] = data_in;
        end
    end

    assign data_out3 = memory[rd_addr];
endmodule

module decoder (act, decoder_en, wr_en0, wr_en1, wr_en2, wr_en3);
    input decoder_en;
    input [1:0] act;
    output wr_en0, wr_en1, wr_en2, wr_en3;

    assign wr_en0 = decoder_en? ((act == 2'b00)? 1 : 0) : 0;
    assign wr_en1 = decoder_en? ((act == 2'b01)? 1 : 0) : 0;
    assign wr_en2 = decoder_en? ((act == 2'b10)? 1 : 0) : 0;
    assign wr_en3 = decoder_en? ((act == 2'b11)? 1 : 0) : 0;
endmodule

module reg32bit (clk, rst, din, dout);
    input clk, rst;
    input [31:0] din;
    output reg [31:0] dout;

    always @(posedge clk ) begin
        if (rst) begin
            dout = 32'd0;
        end else begin
            dout = din;
        end
    end
endmodule

module reward_generator (clk, next_state, step, reward);
    input clk;
    input [3:0] step;
    input [4:0] next_state;
    output [31:0] reward;

    assign reward = (step == 4'b1111)? -32'd50 : (
        (next_state == 5'd25)? 32'd100 : (
            ((next_state == 5'd5) || (next_state == 5'd7) ||
            (next_state == 5'd8) || (next_state == 5'd14) ||
            (next_state == 5'd17) || (next_state == 5'd19) ||
            (next_state == 5'd20) || (next_state == 5'd22)
            )? -32'd100 : 0
        )
    );
    // always @(posedge clk) begin
    //     if (step == 4'b1111) begin
    //         reward = -32'd50;
    //     end 
    //     else begin  
    //         // -100 at demon state
    //         // 100 at 24
    //         case (next_state)
    //             5'd5 : reward = -32'd100;
    //             5'd7 : reward = -32'd100;
    //             5'd8 : reward = -32'd100;
    //             5'd14 : reward = -32'd100;
    //             5'd17 : reward = -32'd100;
    //             5'd19 : reward = -32'd100;
    //             5'd20 : reward = -32'd100;
    //             5'd22 : reward = -32'd100;    
    //             5'd25 : reward = 32'd100; //finish
    //             default: reward = 0;
    //         endcase
    //     end
    // end
endmodule


module Q_updater (Q_sa, Q_max, reward, Q_new);
    input signed [31:0] Q_sa, Q_max, reward;
    output signed [31:0] Q_new;

    wire signed [31:0] mul_gamma, add_reward, min_Qsa, mul_alfa;

    assign mul_gamma = (Q_max >>> 1) + (Q_max >>> 2); //gamma = 0.75
    assign add_reward = mul_gamma + reward;
    assign min_Qsa = add_reward - Q_sa;
    assign mul_alfa = (min_Qsa >>> 1); //alfa = 0.5
    assign Q_new = Q_sa + mul_alfa;
endmodule
    
module QLA (clk, rst, decoder_en, current_state
            , step, next_state, act, Q_max
            , Qnext_0, Qnext_1, Qnext_2, Qnext_3);
    
    input clk, rst, decoder_en;
    input [1:0] act;
    input [3:0] step;
    input [4:0] current_state, next_state;
    output [31:0] Q_max, Qnext_0, Qnext_1, Qnext_2, Qnext_3;

    wire [31:0] Q0, Q1, Q2, Q3, Q_sa;
    wire wr_en0, wr_en1, wr_en2, wr_en3;
    wire [31:0] reward, Q_new;

    //sub component
    ram0 action0(clk, current_state, Q_new, next_state, wr_en0, Qnext_0);
    ram1 action1(clk, current_state, Q_new, next_state, wr_en1, Qnext_1);
    ram2 action2(clk, current_state, Q_new, next_state, wr_en2, Qnext_2);
    ram3 action3(clk, current_state, Q_new, next_state, wr_en3, Qnext_3);

    reg32bit delay0(clk, rst, Qnext_0, Q0);
    reg32bit delay1(clk, rst, Qnext_1, Q1);
    reg32bit delay2(clk, rst, Qnext_2, Q2);
    reg32bit delay3(clk, rst, Qnext_3, Q3);
    
    reward_generator rewardgenerator(clk, next_state, step, reward);
    decoder actdecoder(act, decoder_en, wr_en0, wr_en1, wr_en2, wr_en3);
    mux4 qmux(act, Q0, Q1, Q2, Q3, Q_sa);
    maxQ qmax(Qnext_0, Qnext_1, Qnext_2, Qnext_3, Q_max);
    Q_updater Qupdater(Q_sa, Q_max, reward, Q_new);
endmodule

