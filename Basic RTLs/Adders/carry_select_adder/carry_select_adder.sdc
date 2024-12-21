###############################################################################
# Created by write_sdc
###############################################################################
current_design carry_select_adder
###############################################################################
# Timing Constraints
###############################################################################
# Define a virtual clock with a 20ns period
create_clock -name vclk -period 20.0000

# Adjust input delay to 1ns relative to the virtual clock
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[0]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[1]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[2]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[3]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[4]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[5]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[6]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {A[7]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[0]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[1]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[2]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[3]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[4]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[5]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[6]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {B[7]}]
set_input_delay 1.0000 -clock [get_clocks {vclk}] -add_delay [get_ports {Cin}]

# Adjust output delay to 0.5ns relative to the virtual clock
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Cout}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[0]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[1]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[2]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[3]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[4]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[5]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[6]}]
set_output_delay 0.5000 -clock [get_clocks {vclk}] -add_delay [get_ports {Sum[7]}]
###############################################################################
# Environment
###############################################################################
# Adjust load to 10
set_load -pin_load 10 [get_ports {Cout}]
set_load -pin_load 10 [get_ports {Sum[7]}]
set_load -pin_load 10 [get_ports {Sum[6]}]
set_load -pin_load 10 [get_ports {Sum[5]}]
set_load -pin_load 10 [get_ports {Sum[4]}]
set_load -pin_load 10 [get_ports {Sum[3]}]
set_load -pin_load 10 [get_ports {Sum[2]}]
set_load -pin_load 10 [get_ports {Sum[1]}]
set_load -pin_load 10 [get_ports {Sum[0]}]

# Allow usage of all library cells
# set_attribute carry_select_adder lib_cell_use_policy "ALL"

###############################################################################
# Design Rules  
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_capacitance 0.2000 [current_design]
set_max_fanout 10.0000 [current_design]

# Note: Utilization constraint of 60% is typically managed during placement 
#       and optimization steps in the design flow. Ensure this is reflected
#       in your synthesis or PnR tool configurations.
