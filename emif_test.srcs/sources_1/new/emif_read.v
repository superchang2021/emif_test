`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: ������
// Create Date: 2024/08/12 15:56:28
// Design Name: emif_read
// Module Name: emif_read
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: ����ʹ����Чʱ���������ϵ�������������
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
  input read_en,               //��ʹ��
  input [15:0] data_in,        //EMIF�����ϵ�����
// output
    output read_done_out,
    output [31:0] fpga_read    //FPGA��ȡ��������
);
/**********  reg define  ***********/
reg [31:0] fpga_read_in;
reg [7:0] cnt_en;          //���ƶ����ݵ�N��CLK
reg read_done;             //��һ�ζ�ȡ32bit��������

/**********  assign define  ***********/
assign fpga_read = fpga_read_in;
assign read_done_out = read_done;

//**************************************
//           FPGA��ȡ����   
//**************************************
always @(posedge clk or negedge rst_n) begin
// ��ʼ��
  if(~rst_n) begin
    fpga_read_in <= 32'd0;
    cnt_en <= 8'd0;
    read_done <= 1'b0;
  end
// ��һ�ζ�ȡ��16λ����
  else if(read_en && (cnt_en == 1'b0)) begin
    fpga_read_in[15:0] <= data_in;
    cnt_en <= cnt_en + 1'b1;
  end
// ��һ�ζ�ȡ32bit�������ʱ����read_done���ߣ����ٶ�ȡ
  else if(read_en && (cnt_en == 1'b1)) begin
    fpga_read_in[31:16] <= data_in;
    cnt_en <= cnt_en + 1'b1;
    read_done <= 1'b1;
  end
// ����ʹ��Ϊ��ʱ�����㣬Ϊ��һ����׼��
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
