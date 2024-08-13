`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: 常仁威
// Create Date: 2024/08/12 09:05:48
// Design Name: emif_control
// Module Name: emif_control
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: 当CE和WE/RE同时为低电平后，表示DSP开始读/写FPGA的RAM，经过R_LTNCY个ECLKOUT周期后将角度数据放在/读取数据线上。
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:当CE和WE/RE为低电平时，开启EMIF_CLK计数器，计数W_LTNCY/W_LTNCY后拉给出读/写使能，当CE和WE/RE为出现高电平时，去使能
//////////////////////////////////////////////////////////////////////////////////
module emif_control
#(
parameter W_LTNCY = 8'd2,    //写延时周期
parameter R_LTNCY = 8'd2     //读延时周期
)
(
// sys input
  input clk,
  input rst_n,
// input
  input signal_en,       //低电平选通信号
  input wr_en,           //MCU写使能
  input rd_en,           //MCU读使能
  input emif_clk,        //MCU同步时钟
// output
    output data_wren,    //FPGA的读使能
    output data_rden     //FPGA的写使能
);
/**********  reg define  ***********/
reg data_wren_in;
reg data_rden_in;
reg emif_clk_in1;
reg emif_clk_in2;
reg [31:0] cnt_clk_pose;    //EMIF同步时钟上升沿计数

/**********  wire define  ***********/
wire emif_clk_pose;    //寄存emif_clk的上升沿

/**********  assign define  ***********/
assign emif_clk_pose = emif_clk_in1 & (~emif_clk_in2);    //捕获EMIF时钟上升沿
assign data_wren = data_wren_in;
assign data_rden = data_rden_in;

//**************************************
//         emif_clk 上升沿捕获
//**************************************
always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    emif_clk_in1 <= 1'b0;
    emif_clk_in2 <= 1'b0;
  end
  else begin
    emif_clk_in1 <= emif_clk;
    emif_clk_in2 <= emif_clk_in1;
  end
end

//**************************************
//       开启EMIF_CLK计数器   
//**************************************
always @(posedge clk or negedge rst_n) begin
//初始化
  if(~rst_n) begin
    cnt_clk_pose <= 32'd0;
  end
//写使能计数  
  else if({signal_en,wr_en} == 00) begin
    if(emif_clk_pose) begin
      cnt_clk_pose <= cnt_clk_pose + 1'b1;
    end
    else begin
      cnt_clk_pose <= cnt_clk_pose;
    end
  end
//读使能计数  
  else if({signal_en,rd_en} == 00) begin
    if(emif_clk_pose) begin
        cnt_clk_pose <= cnt_clk_pose + 1'b1;
    end
    else begin
      cnt_clk_pose <= cnt_clk_pose;
    end
  end
//清零
  else begin
    cnt_clk_pose <= 32'd0;
  end
end

//**************************************
//         读写使能同步  
//**************************************
always @(posedge clk or negedge rst_n) begin
// 初始化
  if(~rst_n) begin
    data_wren_in <= 1'b0;
    data_rden_in <= 1'b0;
  end
// 写使能
  else if( (cnt_clk_pose >= W_LTNCY) && (~wr_en)) begin
    data_wren_in <= 1'b1;
  end
// 读使能
  else if( (cnt_clk_pose >= R_LTNCY) && (~rd_en)) begin
    data_rden_in <= 1'b1;
  end
//  清零
  else begin
    data_wren_in <= 1'b0;
    data_rden_in <= 1'b0;
  end

end

endmodule
