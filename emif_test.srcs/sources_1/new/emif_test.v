`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: 常仁威
// Create Date: 2024/08/02 15:51:04
// Design Name: emif_test
// Module Name: emif_test
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: EMIF_TEST顶层文件，测试FPGA与MCU的通讯，具体方式为EMIF通讯
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:FPGA型号 主芯片 XC7S50FGGA484-1、MCU主芯片 TMS320F2837xD
//////////////////////////////////////////////////////////////////////////////////
module emif_test(
// sys_signal input
  input sys_clk,                //系统 时钟输入 50MHz
  input sys_rst_n,              //系统 复位输入
// EMIF enable
  input emif_ce,                //MCU 片选信号 低电平有效
  input emif_we,                //MCU 写数据使能，FPGA 收数据使能 低电平有效
  input emif_re,                //MCU 读数据使能，FPGA 发数据使能 低电平有效
// EMIF clk
  input emif_clk_in,            //MCU 写数据时钟，FPGA 收数据时钟
//    output emif_clk_out,      //MCU 读数据时钟，FPGA 发数据时钟 （可以考虑合并为一个时钟）
// EMIF data
      inout [15:0] emif_data    //EMIF data 16bit角度数据（参考MCU的手册）
);

/**********  parameter define  ***********/
parameter W_LTNCY = 8'd2;        //写延时周期,当CE和WE同时为低电平后，表示DSP开始读FPGA的RAM，经过R_LTNCY个ECLKOUT周期后第一个数据出现在数据总线上。
parameter R_LTNCY = 8'd2;        //读延时周期,当CE和RE同时为低电平后，表示DSP开始往数据总线上写数据，经过W_LTNCY个ECLKOUT周期后第一个数据出现在数据总线上。

/**********  wire define  ***********/
wire emif_clk;            //EMIF同步时钟
wire clk_200M;
wire clk_100M;
wire clk_50M;
wire clk_25M;
wire locked;
wire data_wren;           //FPGA读使能
wire data_rden;           //FPGA写使能
wire read_done;           //读取一次信号，拉高一次
wire [31:0] data_read;    //从MCU读取出来的数据
wire [15:0] emif_data_in;

assign emif_data = (~emif_re)?emif_data_in:16'bz;    //inout 端口用作输入时为高阻态，用作输出时从相应的缓冲寄存器里取值
//assign emif_data = emif_data_in;

//**************************************
//            时钟分频模块
//**************************************
clk_wiz_0 U10_pll(
// Clock out ports
.clk_out1(clk_200M),     // output clk_out1
.clk_out2(clk_100M),     // output clk_out2
.clk_out3(clk_50M),      // output clk_out3
.clk_out4(clk_25M),      // output clk_out4
// Status and control signals
.reset(~sys_rst_n),      // input reset
.locked(locked),         // output locked
// Clock in ports
.clk_in1(sys_clk)        // input clk_in1
);      
//**************************************
//            MCU时钟同步模块
//**************************************
sync_emif_clk U1_sync(
// sys signal
.clk          (clk_200M),       //系统时钟
.rst_n        (sys_rst_n),      //系统复位
//input signal
.clk_in       (emif_clk_in),    //emif传输时钟
//output signal
  .clk_out    (emif_clk)        //emif传输时钟，打拍后输出
);
//**************************************
//           读写控制模块
//**************************************
emif_control #(
.W_LTNCY       (W_LTNCY),       //写延时周期
.R_LTNCY       (R_LTNCY)        //读延时周期
)
U2_control(
// sys signal
.clk           (clk_200M),      //系统时钟
.rst_n         (sys_rst_n),     //系统复位
//input signal
.signal_en     (emif_ce),       //片选使能
.wr_en         (emif_we),       //输入的MCU写使能,FPGA读使能
.rd_en         (emif_re),       //输入的MCU读使能，FPGA写使能
.emif_clk      (emif_clk),      //输入的时钟
//output signal
  .data_wren   (data_wren),     // FPGA读使能
  .data_rden   (data_rden)      // FPGA写使能
);

//**************************************
//          FPGA读数据模块
//**************************************
emif_read U3_emif_read(
// sys signal
.clk          (emif_clk),
.rst_n        (sys_rst_n),
// input signal
.read_en      (data_wren),    //FPGA 读使能
.data_in      (emif_data),    //MCU 输入数据
//output signal
.fpga_read    (data_read),
.read_done_out(read_done)
);

//**************************************
//           FPGA写数据模块
//**************************************
emif_write U4_emif_write(
// sys signal
.clk           (emif_clk),
.rst_n         (sys_rst_n),
// input signal
.write_en      (data_rden),   //FPGA 写使能
//output signal
.fpga_write    (emif_data_in)    //MCU 读取数据

);

endmodule
