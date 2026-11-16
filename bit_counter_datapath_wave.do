onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bit_counter_datapath_tb/clk
add wave -noupdate /bit_counter_datapath_tb/reset
add wave -noupdate /bit_counter_datapath_tb/a
add wave -noupdate /bit_counter_datapath_tb/dut/a_reg
add wave -noupdate /bit_counter_datapath_tb/reset_count
add wave -noupdate /bit_counter_datapath_tb/increment_count
add wave -noupdate /bit_counter_datapath_tb/load_a
add wave -noupdate /bit_counter_datapath_tb/right_shift_a
add wave -noupdate /bit_counter_datapath_tb/a_equals_0
add wave -noupdate /bit_counter_datapath_tb/a0
add wave -noupdate /bit_counter_datapath_tb/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 260
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1784 ps}
