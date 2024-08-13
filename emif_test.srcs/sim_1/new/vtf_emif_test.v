`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/13 11:17:39
// Design Name: 
// Module Name: vtf_emif_test
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
module vtf_emif_test;

reg sys_clk;
reg sys_rst_n;
reg emif_ce;
reg emif_we;
reg emif_re;
reg emif_clk_in;
wire [15:0] emif_data;
//reg [15:0] data;

emif_test uut(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.emif_ce(emif_ce),
.emif_we(emif_we),
.emif_re(emif_re),
.emif_clk_in(emif_clk_in),
.emif_data(emif_data)
);
initial begin
  sys_clk = 0;
  sys_rst_n = 0;
  emif_ce = 1;
  emif_we = 1;
  emif_re = 1;
  emif_clk_in = 0;
//  data = 16'd0;
  # 100; sys_rst_n = 1;
  # 10000; emif_ce = 0;
//  # 20000; emif_we = 0;data = 16'd3;
  # 20000; emif_we = 0;
  # 50000; emif_we = 1;
  # 60000; emif_re = 0;
  # 100000; emif_re = 1;
  # 200000 $stop;
end

always # 5 sys_clk = ~sys_clk;
always # 50 emif_clk_in = ~emif_clk_in;
//assign emif_data = (~emif_re)?16'bz:data;

endmodule
