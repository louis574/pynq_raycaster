`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2026 17:31:41
// Design Name: 
// Module Name: sprite_caster
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sprite_caster(
    input clk,
    input start,
    input rst,
    
    input [15:0] sprite_x, //6.10
    input [15:0] sprite_y,
    input [15:0] pos_x, //6.10
    input [15:0] pos_y,
    input [15:0] dir_x, //2.14
    input [15:0] dir_y,
    input [15:0] plane_x, //2.14
    input [15:0] plane_y,
    
    input [9:0] sprite_dist_lookup_result, // remember 240/distance - and comes one cycle after
    
    output reg [15:0] distance,
    output reg done,
    output reg side_out,
    
    output wire [11:0] sprite_dist_lookup

    );
    
localparam INV_DET = 16'hFC00; // example Q6.10 for the inv matrix det = -cot(fov/2)   
// for a fov of 90' this is = -1 

localparam            
           IDLE = 3'd0,
           START_LET_MULT    = 3'd1,
           SEARCH_LUTS    = 3'd2,
           USE_RESULTS    = 3'd3,
           DONE    = 3'd4;



reg [15:0] transform_x;
reg [15:0] transform_y;


wire [15:0] sprite_diff_x;
wire [15:0] sprite_diff_y;

assign sprite_diff_x = sprite_x - pos_x; // neat little trick - since bit15 is never used in position variables (as it represents 32)
assign sprite_diff_y = sprite_y - pos_y; // we can assume the results are q6.10 twos compliment

wire [31:0] mat_multiply_x ;
wire [31:0] mat_multiply_y ;

wire [31:0] det_multiply_x ;
wire [31:0] det_multiply_y ;

assign mat_multiply_x = $signed(dir_y) * $signed(sprite_diff_x) - $signed(dir_x) * $signed(sprite_diff_y);
assign mat_multiply_y = $signed(plane_x) * $signed(sprite_diff_y) - $signed(plane_y) * $signed(sprite_diff_x);

assign det_multiply_x = $signed(INV_DET) * $signed(mat_multiply_x[31:16]); //6.10 * 8.8 = 14.18
assign det_multiply_y = $signed(INV_DET) * $signed(mat_multiply_y[31:16]);



reg [2:0] control_state;

assign sprite_dist_lookup = transform_y[15:4];

always @(posedge clk) begin
    if(rst) begin
        transform_x <= 16'h0;
        transform_y <= 16'h0;
        control_state <= IDLE;
    end
    else begin
        transform_x <= det_multiply_x[23:8]; //q6.10
        transform_y <= det_multiply_y[23:8];
        
        if(start) begin
            control_state <= START_LET_MULT;
        end
        
        case (control_state)
            START_LET_MULT: begin
                control_state <= SEARCH_LUTS;
            end
            SEARCH_LUTS: begin
                control_state <= USE_RESULTS;
            end
            USE_RESULTS: begin
                
            end
        
        
        endcase
    end

end


endmodule
