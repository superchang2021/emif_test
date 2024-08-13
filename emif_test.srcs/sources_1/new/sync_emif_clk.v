`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DMT
// Engineer: ������
// Create Date: 2024/08/10 16:55:09
// Design Name: sync_emif_clk
// Module Name: sync_emif_clk
// Project Name: emif_test
// Target Devices: AX7050
// Tool Versions: 2019.2
// Description: ��EMIF�������ݵ�ʱ�Ӵ����ȶ���ʹ��
// Dependencies: NONE
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:��һ�� ��ƴ�����
//////////////////////////////////////////////////////////////////////////////////
module sync_emif_clk(
  input clk,
  input rst_n,
  input clk_in,
    output clk_out
);
/**********  reg define  ***********/
reg clk_in1;    //�Ĵ�clk_in
reg clk_in2;    //�Ĵ�clk_in

/**********  assign define  ***********/
assign clk_out = clk_in2;    //�����ĺ��ʱ�����

//**************************************
//            ʱ���źŴ���
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
