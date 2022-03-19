module LFSR(clk, total_iteration, random);
    input clk; 
    input [11:0] total_iteration;
    output [11:0] random; 
    
    reg [11:0] reg_rand; 
    wire feedback; 
    wire [11:0] temp_random;

    parameter init = 12'b001010010110; 
    initial reg_rand = init; 
    assign feedback = reg_rand[10] ^ reg_rand[7]; 
    
    always @ (posedge clk) begin 
        reg_rand = {reg_rand[10:0], feedback}; 
    end
    
    //make sure random number is always less than total iteration
    assign temp_random = (reg_rand > total_iteration)? (reg_rand >>> 4) : (reg_rand);
    assign random = temp_random; 
endmodule

module explore(clk, iteration, total_iteration, random_act, comparison_result);
    input clk;
    input [11:0] iteration, total_iteration;
    output comparison_result;
    output [1:0] random_act;
    
    //testing
    // output [11:0] rand;

    wire [11:0] random;

    LFSR randgen(.clk(clk), .total_iteration(total_iteration), .random(random));
    assign comparison_result = (iteration < random)? 1'b1 : 1'b0;
    assign random_act = random[1:0];

    //testing
    assign rand = random;
endmodule

module exploit(Q_max, in0, in1, in2, in3, qmax_act);
    input [31:0] Q_max, in0, in1, in2, in3;
    output [1:0] qmax_act;

    assign qmax_act= (Q_max == in0) ? 2'b00 :
                        (Q_max == in1) ? 2'b01 :
                        (Q_max == in2) ? 2'b10 : 2'b11;
endmodule

module action_determiner (  clk, iteration, total_iteration,
                            Q_max, in0, in1, in2, in3, act);
    input clk;
    input [11:0] iteration, total_iteration;
    input [31:0] Q_max, in0, in1, in2, in3;
    output [1:0] act;

    wire comparison_result;
    wire [1:0] qmax_act, random_act;

    //sub component
    explore randomact(clk, iteration, total_iteration, random_act, comparison_result);
    exploit qmaxact(Q_max, in0, in1, in2, in3, qmax_act);

    assign act = comparison_result? random_act : qmax_act;
endmodule

