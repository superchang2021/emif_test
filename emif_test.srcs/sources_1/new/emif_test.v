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
// LED
    output [3:0] led,           //led  
// EMIF enable
  input emif_ce_in,                //MCU Ƭѡ�ź� �͵�ƽ��Ч
  input emif_we_in,                //MCU д����ʹ�ܣ�FPGA ������ʹ�� �͵�ƽ��Ч
  input emif_cas,
  input emif_ras,
  input emif_dqm0,
  input emif_dqm1,
  input emif_cke,
// EMIF clk
  input emif_clk_in,            //MCU д����ʱ�ӣ�FPGA ������ʱ��
  input [2:0] emif_addr,       // MCU ��ַ��
// EMIF data
      inout [15:0] emif_data    //EMIF data 16bit�Ƕ����ݣ��ο�MCU���ֲᣩ
);

/**********  wire define  ***********/
wire emif_clk;            //EMIFͬ��ʱ��
wire emif_ce;
wire emif_we;
wire clk_200M;
wire clk_100M;
wire clk_50M;
wire clk_25M;
wire locked;
wire data_wren;           //FPGA��ʹ��
wire data_rden;           //FPGAдʹ��
wire read_done;           //��ȡһ���źţ�����һ��
wire [15:0] data_read;    //��MCU��ȡ����������
wire [15:0] emif_data_in;

wire [12:0] row_addr;
wire [12:0] col_addr;

reg [31:0]   timer;  
reg [3:0] led_reg;
reg [15:0] emif_data_out;

assign led = led_reg;
assign emif_data = emif_data_out;
//assign emif_data = (emif_we_in)?16'b0101010101010101:16'bz;    //inout �˿���������ʱΪ����̬���������ʱ����Ӧ�Ļ���Ĵ�����ȡֵ

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
//            ͬ��ģ��
//**************************************
sync_emif_clk U1_sync(
// sys signal
.clk          (clk_200M),       //ϵͳʱ��
.rst_n        (sys_rst_n),      //ϵͳ��λ
//input signal
.ce_in        (emif_ce_in),
.we_in        (emif_we_in),
.clk_in       (emif_clk_in),    //emif����ʱ��
//output signal
  .clk_out    (emif_clk),        //emif����ʱ�ӣ����ĺ����
  .ce_out     (emif_ce),
  .we_out     (emif_we)
);

//**************************************
//           ��д����ģ��
//**************************************
emif_control U2_control(
// sys signal
.clk           (clk_200M),      //ϵͳʱ��
.rst_n         (sys_rst_n),     //ϵͳ��λ
//input signal
.signal_en     (emif_ce),       //Ƭѡʹ��
.wr_en         (we_logic),       //�����MCUдʹ��,FPGA��ʹ��
.rd_en         (~we_logic),       //�����MCU��ʹ�ܣ�FPGAдʹ��
.emif_clk      (emif_clk),      //�����ʱ��
.emif_addr     (emif_addr),     //�����ַ
.emif_cas      (emif_cas),
.emif_ras      (emif_ras),
.emif_dqm0     (emif_dqm0),
.emif_dqm1     (emif_dqm1),
.emif_cke      (emif_cke),
//output signal
  .row_addr_out(row_addr),
  .col_addr_out(col_addr),
  .data_wren   (data_wren),     // FPGA��ʹ��
  .data_rden   (data_rden)      // FPGAдʹ��
);

//**************************************
//          FPGA������ģ��
//**************************************
emif_read U3_emif_read(
// sys signal
.clk          (clk_200M),
.rst_n        (sys_rst_n),
// input signal
.read_en      (~we_logic),    //FPGA ��ʹ��
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
.clk           (clk_200M),
.rst_n         (sys_rst_n),
// input signal
.write_en      (data_rden),   //FPGA дʹ��
//output signal
.fpga_write    (emif_data_in)    //MCU ��ȡ����

);
//**************************************
//           ���ݴ洢ģ��
//**************************************
reg [15:0] mcu_data [7:0];

always @(posedge sys_clk or negedge sys_rst_n) begin
  if(~sys_rst_n) begin
    mcu_data[0] <= 16'd0;
    mcu_data[1] <= 16'd0;
    mcu_data[2] <= 16'd0;
    mcu_data[3] <= 16'd0;
    mcu_data[4] <= 16'd0;
    mcu_data[5] <= 16'd0;
    mcu_data[6] <= 16'd0;
    mcu_data[7] <= 16'd0;
  end
  else if(read_done) begin
    mcu_data[col_addr[2:0]] <= data_read;
  end
  else begin
    mcu_data[0] <= mcu_data[0];
    mcu_data[1] <= mcu_data[1];
    mcu_data[2] <= mcu_data[2];
    mcu_data[3] <= mcu_data[3];
    mcu_data[4] <= mcu_data[4];
    mcu_data[5] <= mcu_data[5];
    mcu_data[6] <= mcu_data[6];
    mcu_data[7] <= mcu_data[7];
  end
end


//**************************************
//           ILA ���β���
//**************************************

ila_1 ila_1_inst (
	.clk(clk_200M), // input wire clk
	.probe0(emif_clk_in), // input wire [0:0]  probe0  
	.probe1(emif_ce_in), // input wire [0:0]  probe1 
	.probe2(emif_we_in), // input wire [0:0]  probe2 
	.probe3(emif_cas), // input wire [0:0]  probe3 
	.probe4(emif_ras), // input wire [0:0]  probe4 
	.probe5(emif_cke), // input wire [0:0]  probe5 
	.probe6(emif_dqm0), // input wire [0:0]  probe6 
	.probe7(emif_dqm1), // input wire [0:0]  probe7 
	.probe8(emif_data), // input wire [15:0]  probe8 
	.probe9(emif_addr), // input wire [2:0]  probe9 
	.probe10(data_wren), // input wire [0:0]  probe10 
	.probe11(data_rden), // input wire [0:0]  probe11 
	.probe12(read_done), // input wire [0:0]  probe12 
	.probe13(data_read), // input wire [15:0]  probe13 
	.probe14(mcu_data[2]), // input wire [31:0]  probe14
    .probe15(mcu_data[0]),  // input wire [0:0]  probe15
    .probe16(mcu_data[4]),
    .probe17(mcu_data[6]),
    .probe18(col_addr[2:0]),
    .probe19(we_logic),
    .probe20(we_down_cnt)

);

//**************************************
//            LED ��ˮ��ģ��
//**************************************
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (~sys_rst_n) begin                           
    timer <= 32'd0;
  end                     // when the reset signal valid,time counter clearing
  else if (timer == 32'd199_999_999) begin    //4 seconds count(50M*4-1=199999999)
    timer <= 32'd0;                       //count done,clearing the time counter
  end
  else begin
    timer <= timer + 1'b1;            //timer counter = timer counter + 1
  end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
  if (~sys_rst_n) begin                      
    led_reg <= 4'b0000;
  end                  //when the reset signal active         
  else if(timer == 32'd49_999_999) begin    //time counter count to 1st sec,LED1 lighten
    led_reg <= 4'b0001;              
  end   
  else if(timer == 32'd99_999_999) begin   //time counter count to 2nd sec,LED2 lighten
    led_reg <= 4'b0010;                  
  end
  else if (timer == 32'd149_999_999) begin   //time counter count to 3nd sec,LED3 lighten
    led_reg <= 4'b0100;               
  end                           
  else if (timer == 32'd199_999_999) begin   //time counter count to 4nd sec,LED4 lighten
    led_reg <= 4'b1000;               
  end          
end

always @(posedge clk_200M or negedge sys_rst_n) begin
  if(~sys_rst_n) begin
    emif_data_out <= 16'b0101010101010101;
  end
  else if(~we_logic)begin
    emif_data_out <= 16'bz;
  end
  else begin
    emif_data_out <= 16'b0101010101010101;
  end
end


// ����һ���źţ���we�źź�casͬʱΪ�͵�ƽ��ʱ������һ������6��clk��200MHz��ʱ�ӣ�
reg [7:0] we_down_cnt;
reg we_logic;   //��������emif_we_in �Ĺ���

always @(posedge clk_200M or negedge sys_rst_n) begin
  if(~sys_rst_n) begin
    we_logic <= 1'b1;
    we_down_cnt <= 8'd12;
  end
  else if({emif_we_in,emif_cas}==2'b00) begin
    we_down_cnt <= 8'd1;
  end
  else if(we_down_cnt <= 8'd7) begin
    we_logic <= 1'b0;
    we_down_cnt <= we_down_cnt + 1'b1;
  end
  else begin
    we_logic <= 1'b1;
    we_down_cnt <= 8'd12;
  end
end

endmodule
