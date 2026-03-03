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

reg [15:0] dir_x; // cos(a)
reg [15:0] dir_y;  // sin(a)

reg [15:0] plane_x; // the plane vector is the dir vector rotated 90' anticlockwise
reg [15:0] plane_y;

reg [15:0] pos_x; //Q6.10 unsigned
reg [15:0] pos_y;


wire last_h;

wire [4:0] cell_check_x;
wire [4:0] cell_check_y;

reg cell_status; //from bram

wire [15:0] distance;
wire ray_done;

wire [1:0] pxl_val;
wire frame;
wire start_line;
wire last_pixel;

wire [15:0] v_dir_x_r;




reg [31:0] test_map [0:31];

initial $readmemh("test_map.mem", test_map);

always @(posedge clk) begin
    cell_status <= test_map[cell_check_y][cell_check_x];
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
    if(frame) begin  // or use your frame/de signal
        $fwrite(f, "%0d\n", pxl_val);
    end
end


initial begin 
    rst = 1;
    start_pulse = 0;
    dir_x = 16'h2D41; //Q2.14
    dir_y = 16'h2D41;
    
    plane_x = 16'b1110000000000000; 
    plane_y = 16'b0011011101101100;
    
    pos_x = 16'hD2BF; // Q6.10
    pos_y = 16'h2D41;
    #10;
    start_pulse = 1;
    rst = 0;
    #15;
    start_pulse = 0;
    @(posedge frame);
    #200; 
    
    dir_x = 16'h4000;
    dir_y = 16'h0000;
    plane_x = 16'h0000; 
    plane_y = 16'h4000;
    
    @(posedge frame);
    #200;
    
    pos_x = 16'h2000; // Q6.10
    pos_y = 16'h4000;
    
    
    
    #18000000;
    $fclose(f);
    $finish;
end


ray_caster dut (
.clk(clk),
.rst(rst),
.start_pulse(start_pulse),

.dir_x(dir_x), // cos(a)
.dir_y(dir_y),  // sin(a)

.plane_x(plane_x), // the plane vector is the dir vector rotated 90' anticlockwise
.plane_y(plane_y),

.pos_x(pos_x), //Q6.10 unsigned
.pos_y(pos_y),

.last_h(last_h),

.cell_check_x(cell_check_x),
.cell_check_y(cell_check_y),

.cell_status(cell_status), //from bram

.distance(distance),
.ray_done(ray_done),

.vert_height(vert_height),
.vert_height_valid(vert_height_valid),

.pxl_val(pxl_val),
.frame(frame),
.start_line(start_line),
.last_pixel(last_pixel),



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




endmodule
