`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2026 07:11:12
// Design Name: 
// Module Name: ray_caster_tb
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


module ray_caster_tb;

reg clk;
reg rst;
reg start_pulse;
reg tready;



wire last_h;



wire [15:0] distance;
wire ray_done;

wire [23:0] pxl_val;
wire frame;
wire start_line;
wire last_pixel;
wire start_frame;
wire tlast;

wire [15:0] v_dir_x_r;

wire [15:0] bram_search_address;
reg [31:0] bram_data;




reg [31:0] test_map [0:33];

initial $readmemh("test_map.mem", test_map);

always @(posedge clk) begin
    bram_data <= test_map[bram_search_address];
end

initial begin
    clk = 1;
    forever #5 clk = ~clk;
end


/// viewer wires

    wire [15:0] raydir_x;
    wire [15:0] raydir_y;
    
    wire [16:0] i;
    wire [15:0] ray_no;
    
    wire [15:0] deltadistx; // Q6.10 unisgned
    wire [15:0] deltadisty;
    
    wire [15:0] sidedistx;
    wire [15:0] sidedisty;
    
    wire step_x; // 1'b0 = -1, 1'b1 = 1
    wire step_y;
    
        
    wire [15:0] map_x; //q6.10 signed
    wire [15:0] map_y;
    
    //control logic viewer wires
    
    wire frame_in_progress;
    wire start;
    wire new_ray;
    wire new_ray_d; // new_ray delayed by one tick
    wire new_ray_dd; // new_ray delayed by two-ticks
    wire new_ray_ddd;
    wire ray_finished;
    
    wire dda_start;
    
    
    
    wire [8:0] vert_height; // 9 bits
    wire vert_height_valid;
    
    
integer f;
initial f = $fopen("frame.csv", "w");

always @(posedge clk) begin
    if(frame) begin  //
        $fwrite(f, "%0d\n", pxl_val);

    end
end


initial begin 
    tready = 0;
    rst = 1;
    start_pulse = 0;

    #10;
    start_pulse = 1;
    rst = 0;
    #15;
    start_pulse = 0;
    

    #5200000
    
    $readmemh("test_map1.mem", test_map);
    
    
    
    #42000000;
    $fclose(f);
    $finish;
end




ray_caster dut (
.clk(clk),
.rst(rst),
.tready(tready),
.start_pulse(start_pulse),


.addr(bram_search_address),
.bram_data(bram_data),



/*
.dir_x(dir_x), // cos(a)
.dir_y(dir_y),  // sin(a)

.plane_x(plane_x), // the plane vector is the dir vector rotated 90' anticlockwise
.plane_y(plane_y),

.pos_x(pos_x), //Q6.10 unsigned
.pos_y(pos_y),
*/

.last_h(last_h),

/*.cell_check_x(cell_check_x),
.cell_check_y(cell_check_y),

.cell_status(cell_status), //from bram */

.distance(distance),
.ray_done(ray_done),

.vert_height(vert_height),
.vert_height_valid(vert_height_valid),

.pxl_val(pxl_val),
.frame(frame),
.start_line(start_line),
.last_pixel(last_pixel),
.start_frame(start_frame),
.tlast(tlast),



// viewer wires

    .v_raydir_x(raydir_x),
    .v_raydir_y(raydir_y),
    
    .v_i(i),
    .v_ray_no(ray_no),
    
    .v_deltadistx(deltadistx), // Q6.10 unisgned
    .v_deltadisty(deltadisty),
    
    .v_sidedistx(sidedistx),
    .v_sidedisty(sidedisty),
    
    .v_step_x(step_x), // 1'b0 = -1, 1'b1 = 1
    .v_step_y(step_y),
    
        
    .v_map_x(map_x), //q6.10 signed
    .v_map_y(map_y),
    
    
    
    .v_frame_in_progress(frame_in_progress),
    .v_start(start),
    .v_new_ray(new_ray),
    .v_new_ray_d(new_ray_d), // new_ray delayed by one tick
    .v_new_ray_dd(new_ray_dd), // new_ray delayed by two-ticks
    .v_new_ray_ddd(new_ray_ddd),
    .v_ray_finished(ray_finished),
    
    .v_dda_start(dda_start),
    
    .v_dir_x_r(v_dir_x_r)





   
);

// resim as bram only - no dir - pos etc etc etc !!!!!!


endmodule
