`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: 常仁威
// Create Date: 2024/08/12 15:56:28
// Design Name: emif_read
// Module Name: emif_read
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: 当读使能有效时，将总线上的数据锁存下来
// Dependencies: emif_control
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:NONE
//////////////////////////////////////////////////////////////////////////////////
module emif_read(
// sys input
  input clk,
  input rst_n,
// input
  input read_en,               //读使能
  input [15:0] data_in,        //EMIF总线上的数据
// output
    output read_done_out,
    output [31:0] fpga_read    //FPGA读取到的数据
);
/**********  reg define  ***********/
reg [31:0] fpga_read_in;
reg [7:0] cnt_en;          //控制读数据第N个CLK
reg read_done;             //第一次读取32bit数据拉高

/**********  assign define  ***********/
assign fpga_read = fpga_read_in;
assign read_done_out = read_done;

//**************************************
//           FPGA读取数据   
//**************************************
always @(posedge clk or negedge rst_n) begin
// 初始化
  if(~rst_n) begin
    fpga_read_in <= 32'd0;
    cnt_en <= 8'd0;
    read_done <= 1'b0;
  end
// 第一次读取低16位数据
  else if(read_en && (cnt_en == 1'b0)) begin
    fpga_read_in[15:0] <= data_in;
    cnt_en <= cnt_en + 1'b1;
  end
// 第一次读取32bit数据完成时，将read_done拉高，不再读取
  else if(read_en && (cnt_en == 1'b1)) begin
    fpga_read_in[31:16] <= data_in;
    cnt_en <= cnt_en + 1'b1;
    read_done <= 1'b1;
  end
// 当读使能为低时，清零，为下一次做准备
  else if (~read_en) begin
    fpga_read_in <= 32'd0;
    cnt_en <= 8'd0;
    read_done <= 1'b0;
  end
// default
  else begin
    fpga_read_in <= fpga_read_in;
    cnt_en <= cnt_en;
    read_done <= read_done;
  end

end

endmodule
