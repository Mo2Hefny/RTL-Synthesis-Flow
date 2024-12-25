create_clock -name virtual_clock -period 20 

set_propagated_clock [get_clocks virtual_clock]

set_input_delay 1 [all_inputs] -clock virtual_clock

set_output_delay 0.5 [all_outputs] -clock virtual_clock

set_load 0.01 [all_outputs]

set_clock_uncertainty 0.2 [get_clocks virtual_clock]

set_clock_latency 0.2 [get_clocks virtual_clock]
