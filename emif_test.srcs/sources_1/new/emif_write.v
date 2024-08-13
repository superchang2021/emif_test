`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: U4_emif_write : emif_write (emif_write.v) emif_write.v
// Create Date: 2024/08/12 16:55:07
// Design Name: emif_write
// Module Name: emif_write
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: 当写使能有效时（高电平），将角度数据送到总线上
// Dependencies: emif_control
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:NONE
//////////////////////////////////////////////////////////////////////////////////
module emif_write(
// sys
  input clk,
  input rst_n,
// input 
  input write_en,
// output
    output [15:0] fpga_write
);

reg [15:0] fpga_write_in;    //
reg [7:0] cnt_en;            //控制写数据第N个CLK

assign fpga_write = fpga_write_in;

always @(posedge clk or negedge rst_n) begin
// 初始化
  if(~rst_n) begin
    fpga_write_in <= 16'd0;
    cnt_en <= 8'd0;
  end
// 只在第一个CLK写入数据
  else if(write_en && (cnt_en == 1'b0)) begin
    fpga_write_in <= cnt_en + 1'b1;
    cnt_en <= cnt_en + 1'b1;
  end
// 只在第二个CLK写入数据
  else if(write_en && (cnt_en == 1'b1)) begin
    fpga_write_in <= cnt_en + 1'b1;
    cnt_en <= cnt_en + 1'b1;
  end
// 去使能 清零
  else if(~write_en) begin
    fpga_write_in <= 16'd0;
    cnt_en <= 8'd0;
  end
// default
  else begin
    fpga_write_in <= fpga_write_in;
    cnt_en <= cnt_en;
  end
end

endmodule
