module CU (clk, rst, next_state, change_iteration, done, total_iteration_in, step, total_iteration, iteration);
    input clk, rst;
    input [4:0] next_state;
    input [11:0] total_iteration_in;
    output reg change_iteration, done;
    output [3:0] step;
    output [11:0] total_iteration, iteration;

    reg [3:0] step_counter;
    reg [11:0] total_iteration_reg, iteration_counter;

    always @(posedge clk ) begin
        if(rst) begin
            total_iteration_reg <= total_iteration_in;
            step_counter <= 4'd0;
            iteration_counter <= 12'd0;
            done <= 0;
        end
        else begin
            step_counter <= step_counter + 4'd1;
            change_iteration = 1'b0;
            if (next_state == 5'd25) begin
                step_counter <= 4'd14;
            end
            if (step_counter == 4'd14) begin
                change_iteration = 1'b1;
            end
            if (step_counter == 4'd15) begin
                step_counter <= 4'd0;
                iteration_counter <= iteration_counter + 1;
            end
            if (iteration_counter == total_iteration_reg) begin
                done <= 1;
            end
        end
    end

    assign step = step_counter;
    assign iteration = iteration_counter;
    assign total_iteration = total_iteration_reg;
endmodule 