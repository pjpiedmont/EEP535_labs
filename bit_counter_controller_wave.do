onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bit_counter_controller_tb/clk
add wave -noupdate /bit_counter_controller_tb/reset
add wave -noupdate /bit_counter_controller_tb/start
add wave -noupdate /bit_counter_controller_tb/a0
add wave -noupdate /bit_counter_controller_tb/a_equals_0
add wave -noupdate /bit_counter_controller_tb/reset_count
add wave -noupdate /bit_counter_controller_tb/increment_count
add wave -noupdate /bit_counter_controller_tb/load_a
add wave -noupdate /bit_counter_controller_tb/right_shift_a
add wave -noupdate /bit_counter_controller_tb/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
