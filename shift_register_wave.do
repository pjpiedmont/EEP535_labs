onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /shift_register_tb/clk
add wave -noupdate /shift_register_tb/reset
add wave -noupdate /shift_register_tb/mode
add wave -noupdate /shift_register_tb/left_in
add wave -noupdate /shift_register_tb/right_in
add wave -noupdate /shift_register_tb/parallel_in
add wave -noupdate /shift_register_tb/parallel_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 197
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
WaveRestoreZoom {0 ps} {2204 ps}
