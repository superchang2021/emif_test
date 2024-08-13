`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: 常仁威
// Create Date: 2024/08/10 16:55:09
// Design Name: sync_emif_clk
// Module Name: sync_emif_clk
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: 将EMIF传输数据的时钟打拍稳定后使用
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:第一版 设计打两拍
//////////////////////////////////////////////////////////////////////////////////
module sync_emif_clk(
  input clk,
  input rst_n,
  input clk_in,
    output clk_out
);
/**********  reg define  ***********/
reg clk_in1;    //寄存clk_in
reg clk_in2;    //寄存clk_in

/**********  assign define  ***********/
assign clk_out = clk_in2;    //将打拍后的时钟输出

//**************************************
//            时钟信号打拍
//**************************************
always @(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    clk_in1 <= 1'b0;
    clk_in2 <= 1'b0;
  end
  else begin
    clk_in1 <= clk_in;
    clk_in2 <= clk_in1;
  end
end

endmodule
