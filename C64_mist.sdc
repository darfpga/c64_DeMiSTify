# Set Clock 
set C64_sdram_clk ${topmodule}pll|altpll_component|auto_generated|pll1|clk[*]
set 1541_clk ${topmodule}pll_2|altpll_component|auto_generated|pll1|clk[0]
set sdram_clk ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]
set sysclk ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]


# SPI ports
set_input_delay -add_delay  -clock_fall -clock [get_clocks spiclk]  1.000 [get_ports {SPI_DI}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks spiclk]  1.000 [get_ports spiclk]
set_input_delay -add_delay  -clock_fall -clock [get_clocks spiclk]  1.000 [get_ports {SPI_SS2}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks spiclk]  1.000 [get_ports {SPI_SS3}]
set_output_delay -add_delay  -clock_fall -clock [get_clocks spiclk] 1.000 [get_ports {SPI_DO}]

# Clock groups
set_clock_groups -asynchronous -group [get_clocks spiclk] -group [get_clocks $C64_sdram_clk]
set_clock_groups -asynchronous -group [get_clocks spiclk] -group [get_clocks $1541_clk]
set_clock_groups -asynchronous -group [get_clocks $1541_clk] -group [get_clocks $C64_sdram_clk]

# Some relaxed constrain to the VGA pins. The signals should arrive together, the delay is not really important.
set_output_delay -clock [get_clocks $sysclk] -max 0 [get_ports $VGA_OUT]
set_output_delay -clock [get_clocks $sysclk] -min -5 [get_ports $VGA_OUT]

set_multicycle_path -to $VGA_OUT -setup 2
set_multicycle_path -to $VGA_OUT -hold 1

# SDRAM delays
set_input_delay -clock [get_clocks $sdram_clk] -max 6.4 [get_ports $RAM_IN]
set_input_delay -clock [get_clocks $sdram_clk] -min 3.2 [get_ports $RAM_IN]

set_output_delay -clock [get_clocks $sdram_clk] -max 1.5 [get_ports $RAM_OUT]
set_output_delay -clock [get_clocks $sdram_clk] -min -0.8 [get_ports $RAM_OUT]

# False paths
set_false_path -to ${FALSE_OUT}
set_false_path -from ${FALSE_IN}
