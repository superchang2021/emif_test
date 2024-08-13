`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: ������
// Create Date: 2024/08/12 09:05:48
// Design Name: emif_control
// Module Name: emif_control
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: ��CE��WE/REͬʱΪ�͵�ƽ�󣬱�ʾDSP��ʼ��/дFPGA��RAM������R_LTNCY��ECLKOUT���ں󽫽Ƕ����ݷ���/��ȡ�������ϡ�
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:��CE��WE/REΪ�͵�ƽʱ������EMIF_CLK������������W_LTNCY/W_LTNCY����������/дʹ�ܣ���CE��WE/REΪ���ָߵ�ƽʱ��ȥʹ��
//////////////////////////////////////////////////////////////////////////////////
module emif_control
#(
parameter W_LTNCY = 8'd2,    //д��ʱ����
parameter R_LTNCY = 8'd2     //����ʱ����
)
(
// sys input
  input clk,
  input rst_n,
// input
  input signal_en,       //�͵�ƽѡͨ�ź�
  input wr_en,           //MCUдʹ��
  input rd_en,           //MCU��ʹ��
  input emif_clk,        //MCUͬ��ʱ��
// output
    output data_wren,    //FPGA�Ķ�ʹ��
    output data_rden     //FPGA��дʹ��
);
/**********  reg define  ***********/
reg data_wren_in;
reg data_rden_in;
reg emif_clk_in1;
reg emif_clk_in2;
reg [31:0] cnt_clk_pose;    //EMIFͬ��ʱ�������ؼ���

/**********  wire define  ***********/
wire emif_clk_pose;    //�Ĵ�emif_clk��������

/**********  assign define  ***********/
assign emif_clk_pose = emif_clk_in1 & (~emif_clk_in2);    //����EMIFʱ��������
assign data_wren = data_wren_in;
assign data_rden = data_rden_in;

//**************************************
//         emif_clk �����ز���
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
//       ����EMIF_CLK������   
//**************************************
always @(posedge clk or negedge rst_n) begin
//��ʼ��
  if(~rst_n) begin
    cnt_clk_pose <= 32'd0;
  end
//дʹ�ܼ���  
  else if({signal_en,wr_en} == 00) begin
    if(emif_clk_pose) begin
      cnt_clk_pose <= cnt_clk_pose + 1'b1;
    end
    else begin
      cnt_clk_pose <= cnt_clk_pose;
    end
  end
//��ʹ�ܼ���  
  else if({signal_en,rd_en} == 00) begin
    if(emif_clk_pose) begin
        cnt_clk_pose <= cnt_clk_pose + 1'b1;
    end
    else begin
      cnt_clk_pose <= cnt_clk_pose;
    end
  end
//����
  else begin
    cnt_clk_pose <= 32'd0;
  end
end

//**************************************
//         ��дʹ��ͬ��  
//**************************************
always @(posedge clk or negedge rst_n) begin
// ��ʼ��
  if(~rst_n) begin
    data_wren_in <= 1'b0;
    data_rden_in <= 1'b0;
  end
// дʹ��
  else if( (cnt_clk_pose >= W_LTNCY) && (~wr_en)) begin
    data_wren_in <= 1'b1;
  end
// ��ʹ��
  else if( (cnt_clk_pose >= R_LTNCY) && (~rd_en)) begin
    data_rden_in <= 1'b1;
  end
//  ����
  else begin
    data_wren_in <= 1'b0;
    data_rden_in <= 1'b0;
  end

end

endmodule
