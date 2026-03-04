`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2026 17:47:57
// Design Name: 
// Module Name: hdmi_pixel_stream_gen
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


module hdmi_pixel_stream_gen(
input clk,
input rst,

input [8:0] vert_half_height,
input side_in,
input vert_height_valid,
input [15:0] ray_no,

input last_h,

output wire [1:0] pxl_val, //00 white, 01 grey, 10 green, 11 blue
output reg frame_d,
output reg start_line_d,
output reg last_pixel

 

    );
    
wire frame;
reg start_line;
    
reg [8:0] next_heights [0:719];
reg [8:0] current_heights [0:719];
reg next_side [0:719];
reg current_side [0:719];

reg [9:0] x_coord;
reg [9:0] y_coord;

reg in_frame;

reg stream_started;

reg frame_gap;

integer i;

wire [8:0] half_height_read;

wire strip_side;
// new
reg [1:0] pxl_val_r;
assign pxl_val = pxl_val_r;

wire in_wall = (y_coord >= (10'd360 - {1'b0, half_height_read}) && 
                y_coord <= (10'd360 + {1'b0, half_height_read}));

always @(posedge clk) begin
    pxl_val_r <= in_wall ? 
                 (strip_side ? 2'b01 : 2'b00) :
                 ((y_coord >= 10'd360) ? 2'b10 : 2'b11);
end


//

assign frame = in_frame;

assign half_height_read = current_heights[x_coord];
assign strip_side = current_side[x_coord];





/*
assign pxl_val = in_wall ? (strip_side ? 2'b01 : 2'b00) : (
                 (y_coord >= 10'd360) ? 2'b10: 2'b11);

*/
always @(posedge clk) begin
    if(rst) begin
        start_line <= 1'b0;
        last_pixel <= 1'b0;
        in_frame <= 1'b0;
        x_coord <= 10'h0;
        y_coord <= 10'h0;
        stream_started <= 1'b0;
        frame_gap <= 1'b0;
        frame_d <= 1'b0;
        start_line_d <= 1'b0;
    end
    
    else if (last_pixel) begin
        last_pixel <= 1'b0;
        in_frame <= 1'b0;
        frame_gap <= 1'b1;
        
        frame_d <= frame;
        start_line_d <= start_line;
    end
    
    else begin
    
        frame_d <= frame;
        start_line_d <= start_line;
    
        if(vert_height_valid) begin
            next_heights[ray_no] <= vert_half_height;
            next_side[ray_no] <= side_in; 
        end
        
        if(last_h && !stream_started) begin
            x_coord <= 10'h0;
            y_coord <= 10'h0;
            in_frame <= 1'b1;
            start_line <= 1'b1;
            stream_started <= 1'b1;

            for(i = 0; i < 720; i=i+1) begin
                current_heights[i] <= next_heights[i];
                current_side[i] <= next_side[i];
            end
        end
        if(frame_gap) begin
            frame_gap <= 1'b0;
            x_coord <= 10'h0;
            y_coord <= 10'h0;
            in_frame <= 1'b1;
            start_line <= 1'b1;

            for(i = 0; i < 720; i=i+1) begin
                current_heights[i] <= next_heights[i];
                current_side[i] <= next_side[i];
            end
        end
        if(in_frame) begin
            if(start_line) begin
                start_line <= 1'b0;
            end
            if(x_coord == 10'd719 && y_coord == 10'd719) begin
                in_frame <= 1'b0;
                last_pixel <= 1'b1;
                x_coord <= 10'h0;
                y_coord <= 10'h0;
            end
            else if(x_coord == 10'd719) begin
                x_coord <= 10'd0;
                y_coord <= y_coord+1;
                start_line <= 1'b1;
                
            end
            else begin
                x_coord <= x_coord + 1;
            end
        
        
        
        
        end
    end
end
    
    
    

    
    
    
endmodule
