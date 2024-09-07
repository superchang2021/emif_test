#################### NET- ISOTANDARD ####################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
#################### SPI configurate setting ####################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
#################### clock  setting ####################
create_clock -period 20 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]
set_property PACKAGE_PIN P15 [get_ports {sys_clk}]

#################### reset  setting ####################
set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]
set_property PACKAGE_PIN AB2 [get_ports {sys_rst_n}]

#################### in/output  setting ####################
set_property IOSTANDARD LVCMOS33 [get_ports {emif_clk_in}]
set_property PACKAGE_PIN AA20 [get_ports {emif_clk_in}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_ce_in}]
set_property PACKAGE_PIN AB20 [get_ports {emif_ce_in}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_we_in}]
set_property PACKAGE_PIN Y22 [get_ports {emif_we_in}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_cas}]
set_property PACKAGE_PIN AA22 [get_ports {emif_cas}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_ras}]
set_property PACKAGE_PIN N20 [get_ports {emif_ras}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_cke}]
set_property PACKAGE_PIN P21 [get_ports {emif_cke}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_dqm0}]
set_property PACKAGE_PIN T21 [get_ports {emif_dqm0}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_dqm1}]
set_property PACKAGE_PIN V22 [get_ports {emif_dqm1}]

#################### data  setting ####################
set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[0]}]
set_property PACKAGE_PIN T19 [get_ports {emif_data[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[1]}]
set_property PACKAGE_PIN U20 [get_ports {emif_data[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[2]}]
set_property PACKAGE_PIN W21 [get_ports {emif_data[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[3]}]
set_property PACKAGE_PIN P17 [get_ports {emif_data[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[4]}]
set_property PACKAGE_PIN N15 [get_ports {emif_data[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[5]}]
set_property PACKAGE_PIN R17 [get_ports {emif_data[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[6]}]
set_property PACKAGE_PIN U17 [get_ports {emif_data[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[7]}]
set_property PACKAGE_PIN U19 [get_ports {emif_data[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[8]}]
set_property PACKAGE_PIN V19 [get_ports {emif_data[8]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[9]}]
set_property PACKAGE_PIN W22 [get_ports {emif_data[9]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[10]}]
set_property PACKAGE_PIN U22 [get_ports {emif_data[10]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[11]}]
set_property PACKAGE_PIN T22 [get_ports {emif_data[11]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[12]}]
set_property PACKAGE_PIN P22 [get_ports {emif_data[12]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[13]}]
set_property PACKAGE_PIN P20 [get_ports {emif_data[13]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[14]}]
set_property PACKAGE_PIN AB21 [get_ports {emif_data[14]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_data[15]}]
set_property PACKAGE_PIN Y20 [get_ports {emif_data[15]}]
#############LED Setting###########################
set_property PACKAGE_PIN H16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN G16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN K15 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN J15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

#############address Setting###########################
set_property IOSTANDARD LVCMOS33 [get_ports {emif_addr[0]}]
set_property PACKAGE_PIN T20 [get_ports {emif_addr[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_addr[1]}]
set_property PACKAGE_PIN V20 [get_ports {emif_addr[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {emif_addr[2]}]
set_property PACKAGE_PIN Y21 [get_ports {emif_addr[2]}]

