`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2026 19:42:15
// Design Name: 
// Module Name: dda_main_body
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


module dda_main_body(
    input clk,
    input start,
    input rst,
    
    input cell_status, //from bram
    
    input [20:0] side_disty,
    input [17:0] delta_disty, //6.12
    input [15:0] map_y,
    input stepy,
    input [20:0] side_distx,
    input [17:0] delta_distx,  //6.12
    input [15:0] map_x,
    input stepx,
    
    output reg [15:0] distance,
    output reg ray_done,
    output reg side_out,
    
    output wire [4:0] cell_check_x,
    output wire [4:0] cell_check_y 
    

    );
    
    reg dda_in_progress;
    reg bram_check_cycle;
    reg dda_load_cycle;

    
    reg [22:0] r_side_disty;
    reg [17:0] r_delta_disty;
    reg [15:0] r_map_y;
    reg r_stepy;
    reg [22:0] r_side_distx;
    reg [17:0] r_delta_distx;
    reg [15:0] r_map_x;
    reg r_stepx;
    
    reg side;
    
    
    
    
wire [15:0] next_map_x = r_side_distx < r_side_disty ? 
    r_map_x + (r_stepx ? 16'h0400 : 16'hFC00) : r_map_x;
wire [15:0] next_map_y = r_side_distx < r_side_disty ? 
    r_map_y : r_map_y + (r_stepy ? 16'h0400 : 16'hFC00);
    
 
assign cell_check_x = next_map_x[14:10];
assign cell_check_y = next_map_y[14:10];

wire [20:0] distance_sub_x;
wire [20:0] distance_sub_y;
    
assign distance_sub_y = (r_side_disty - r_delta_disty + 2'b10);
assign distance_sub_x = (r_side_distx - r_delta_distx + 2'b10);
    
    always @(posedge clk) begin
        if(rst) begin
            dda_in_progress <= 1'b0;
            bram_check_cycle <= 1'b0;
            ray_done <= 1'b0;
            dda_load_cycle <= 1'b0;
        end
        else
            if(start) begin
                dda_load_cycle <= 1'b1;
                dda_in_progress <= 1'b0;

                bram_check_cycle <= 1'b0;
                ray_done <= 1'b0;
                
                r_side_disty <= side_disty;
                r_delta_disty <= delta_disty;
                r_map_y <= map_y;
                r_stepy <= stepy;
                r_side_distx <= side_distx;
                r_delta_distx <= delta_distx;
                r_map_x <= map_x;
                r_stepx <= stepx;
      
            end
            else if (ray_done) begin
                ray_done <= 1'b0;
            end
            else if(dda_load_cycle) begin // this stops us from reading stale map values
                dda_load_cycle <= 1'b0;
                dda_in_progress <= 1'b1;
            end
            
            else if(dda_in_progress) begin
                if(bram_check_cycle) begin
                        // check if wall hit
                    bram_check_cycle <= 1'b0;
                    
                    if(cell_status) begin // wall hit
                        dda_in_progress <= 1'b0;
                        ray_done <= 1'b1;
                        side_out <= side;
                        
                        if(side) begin
                            distance <= distance_sub_y[17:2];
                        end
                        else begin
                            distance <= distance_sub_x[17:2];
                        end
                        
                    end
                end
                else begin
                    r_map_x <= next_map_x;
                    r_map_y <= next_map_y;
                    bram_check_cycle <= 1'b1;
                    
                    if(r_side_distx < r_side_disty) begin

                        
                        
                        r_side_distx <= r_side_distx + r_delta_distx;


                        side <= 1'b0;
                    end
                    else begin

                        r_side_disty <= r_side_disty + r_delta_disty;

                        side <= 1'b1;
                    end
                
                end
            end
        end
    
    
    
    
    
    
    
endmodule
