module regposition_state (clk, rst, din, dout);
    input clk, rst;
    input [2:0] din;
    output reg [2:0] dout;

    always @(posedge clk ) begin
        if (rst) begin
            dout <= 3'd1;
        end else begin
            dout <= din;    
        end
    end
endmodule

module reg_5bit( clk, rst, din, dout);
    input clk, rst;
    input [4:0] din;
    output reg [4:0] dout;

    always @(posedge clk ) begin
        if(rst) begin
            dout <= 5'd1;
        end
        else begin
            dout <= din;
        end
    end
endmodule

module checker (clk, rst, change_iteration, act, curr_state, next_state, decoder_en);
    input clk, rst, change_iteration;
    input [1:0] act; 
    output [4:0] curr_state, next_state;
    output decoder_en;

    reg initial_i = 3'd1;
    reg initial_j = 3'd1;

    wire [2:0] i_new, j_new, i_next, j_next;
    wire [2:0] i_current,j_current,i_current_moved,j_current_moved;
    // wire [4:0] temp_state;
    wire [4:0] current_state;
    
    regposition_state regpos_i (clk, rst, i_next, i_current);
    regposition_state regpos_j (clk, rst, j_next, j_current);
    // reg_5bit regstate0 (clk, rst, temp_state, next_state);
    reg_5bit regstate1 (clk, rst, next_state, current_state);

    assign i_next = (change_iteration || rst)? initial_i : i_new;
    assign j_next = (change_iteration || rst)? initial_j : j_new;
    //act 0 go right, act 2 go left
    //act 1 go up, act 3 go down
    assign #1 i_current_moved = (change_iteration || rst)? 3'd1 : ((act == 2'd1)? (i_current - 3'd1) : ((act == 2'd3)? (i_current + 3'd1) : i_current));
    assign #1 j_current_moved = (change_iteration || rst)? 3'd1 : ((act == 2'd2)? (j_current - 3'd1) : ((act == 2'd0)? (j_current + 3'd1) : j_current));

    assign #1 i_new = ((i_current_moved == 3'd0) || (i_current_moved == 3'd6))? i_current : i_current_moved;
    assign #1 j_new = ((j_current_moved == 3'd0) || (j_current_moved == 3'd6))? j_current : j_current_moved;
    
    assign curr_state = current_state;
    assign next_state = ((i_next - 1)*5) + j_next;
    assign decoder_en = (next_state == current_state)? 0 : 1;
endmodule

