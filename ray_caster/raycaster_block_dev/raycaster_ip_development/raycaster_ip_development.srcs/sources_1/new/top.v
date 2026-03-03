`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2026 17:34:32
// Design Name: 
// Module Name: top
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


module top #(
parameter SCREEN_HEIGHT = 480,
parameter SCREEN_WIDTH = 720,
parameter MAP_WIDTH = 32,
parameter MAP_HEIGHT = 32,
parameter COORD_SIZE = 32,
parameter COORD_FRAC_BITS = 16,
parameter angle_width = 12,
parameter dwidth = 16
)


(
    input   clk,  
    
    input   [COORD_SIZE-1:0]  bread_d,
    output  [COORD_SIZE-1:0]  radd,
        
    output  bclk,
    output  enb,
    output  rstb,
    output  [3:0]   bwen,
    output  [COORD_SIZE-1:0]  bwrite_d       
    );
    
    assign bclk = clk;
    
    // disable write operation
    
    assign enb = 1'b1;
    assign rstb = 1'b0;
    assign bwen = 4'b0000;
    assign bwrite_d = 'h0;
    
    
    // reading port b
    
    

    
    assign radd = 'h0;
     
endmodule
