onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /hazard_lights_testbench/clk
add wave -noupdate -label reset /hazard_lights_testbench/reset
add wave -noupdate -label wind_dir /hazard_lights_testbench/wind
add wave -noupdate -label ps /hazard_lights_testbench/dut/ps
add wave -noupdate -label ns /hazard_lights_testbench/dut/ns
add wave -noupdate -label lights /hazard_lights_testbench/lights
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
