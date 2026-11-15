onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate {/DE1_SoC_tb/KEY[3]}
add wave -noupdate /DE1_SoC_tb/dut/KEY3_sync
add wave -noupdate /DE1_SoC_tb/dut/reset
add wave -noupdate {/DE1_SoC_tb/KEY[0]}
add wave -noupdate /DE1_SoC_tb/dut/KEY0_sync
add wave -noupdate /DE1_SoC_tb/dut/KEY0_edge
add wave -noupdate /DE1_SoC_tb/HEX3
add wave -noupdate /DE1_SoC_tb/HEX2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 203
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
WaveRestoreZoom {0 ps} {1884 ps}
