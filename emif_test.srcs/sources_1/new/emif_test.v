`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: ������
// Create Date: 2024/08/02 15:51:04
// Design Name: emif_test
// Module Name: emif_test
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: EMIF_TEST�����ļ�������FPGA��MCU��ͨѶ�����巽ʽΪEMIFͨѶ
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:FPGA�ͺ� ��оƬ XC7S50FGGA484-1��MCU��оƬ TMS320F2837xD
//////////////////////////////////////////////////////////////////////////////////
module emif_test(
// sys_signal input
  input sys_clk,                //ϵͳ ʱ������ 50MHz
  input sys_rst_n,              //ϵͳ ��λ����
// EMIF enable
  input emif_ce,                //MCU Ƭѡ�ź� �͵�ƽ��Ч
  input emif_we,                //MCU д����ʹ�ܣ�FPGA ������ʹ�� �͵�ƽ��Ч
  input emif_re,                //MCU ������ʹ�ܣ�FPGA ������ʹ�� �͵�ƽ��Ч
// EMIF clk
  input emif_clk_in,            //MCU д����ʱ�ӣ�FPGA ������ʱ��
//    output emif_clk_out,      //MCU ������ʱ�ӣ�FPGA ������ʱ�� �����Կ��Ǻϲ�Ϊһ��ʱ�ӣ�
// EMIF data
      inout [15:0] emif_data    //EMIF data 16bit�Ƕ����ݣ��ο�MCU���ֲᣩ
);

/**********  parameter define  ***********/
parameter W_LTNCY = 8'd2;        //д��ʱ����,��CE��WEͬʱΪ�͵�ƽ�󣬱�ʾDSP��ʼ��FPGA��RAM������R_LTNCY��ECLKOUT���ں��һ�����ݳ��������������ϡ�
parameter R_LTNCY = 8'd2;        //����ʱ����,��CE��REͬʱΪ�͵�ƽ�󣬱�ʾDSP��ʼ������������д���ݣ�����W_LTNCY��ECLKOUT���ں��һ�����ݳ��������������ϡ�

/**********  wire define  ***********/
wire emif_clk;            //EMIFͬ��ʱ��
wire clk_200M;
wire clk_100M;
wire clk_50M;
wire clk_25M;
wire locked;
wire data_wren;           //FPGA��ʹ��
wire data_rden;           //FPGAдʹ��
wire read_done;           //��ȡһ���źţ�����һ��
wire [31:0] data_read;    //��MCU��ȡ����������
wire [15:0] emif_data_in;

assign emif_data = (~emif_re)?emif_data_in:16'bz;    //inout �˿���������ʱΪ����̬���������ʱ����Ӧ�Ļ���Ĵ�����ȡֵ
//assign emif_data = emif_data_in;

//**************************************
//            ʱ�ӷ�Ƶģ��
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
//            MCUʱ��ͬ��ģ��
//**************************************
sync_emif_clk U1_sync(
// sys signal
.clk          (clk_200M),       //ϵͳʱ��
.rst_n        (sys_rst_n),      //ϵͳ��λ
//input signal
.clk_in       (emif_clk_in),    //emif����ʱ��
//output signal
  .clk_out    (emif_clk)        //emif����ʱ�ӣ����ĺ����
);
//**************************************
//           ��д����ģ��
//**************************************
emif_control #(
.W_LTNCY       (W_LTNCY),       //д��ʱ����
.R_LTNCY       (R_LTNCY)        //����ʱ����
)
U2_control(
// sys signal
.clk           (clk_200M),      //ϵͳʱ��
.rst_n         (sys_rst_n),     //ϵͳ��λ
//input signal
.signal_en     (emif_ce),       //Ƭѡʹ��
.wr_en         (emif_we),       //�����MCUдʹ��,FPGA��ʹ��
.rd_en         (emif_re),       //�����MCU��ʹ�ܣ�FPGAдʹ��
.emif_clk      (emif_clk),      //�����ʱ��
//output signal
  .data_wren   (data_wren),     // FPGA��ʹ��
  .data_rden   (data_rden)      // FPGAдʹ��
);

//**************************************
//          FPGA������ģ��
//**************************************
emif_read U3_emif_read(
// sys signal
.clk          (emif_clk),
.rst_n        (sys_rst_n),
// input signal
.read_en      (data_wren),    //FPGA ��ʹ��
.data_in      (emif_data),    //MCU ��������
//output signal
.fpga_read    (data_read),
.read_done_out(read_done)
);

//**************************************
//           FPGAд����ģ��
//**************************************
emif_write U4_emif_write(
// sys signal
.clk           (emif_clk),
.rst_n         (sys_rst_n),
// input signal
.write_en      (data_rden),   //FPGA дʹ��
//output signal
.fpga_write    (emif_data_in)    //MCU ��ȡ����

);

endmodule
