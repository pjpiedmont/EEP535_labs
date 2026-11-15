onerror {resume}
quietly virtual function -install /DE1_SoC_tb -env /DE1_SoC_tb { &{/DE1_SoC_tb/SW[8], /DE1_SoC_tb/SW[7], /DE1_SoC_tb/SW[6], /DE1_SoC_tb/SW[5], /DE1_SoC_tb/SW[4] }} SW_8_4
quietly virtual function -install /DE1_SoC_tb -env /DE1_SoC_tb { &{/DE1_SoC_tb/SW[3], /DE1_SoC_tb/SW[2], /DE1_SoC_tb/SW[1], /DE1_SoC_tb/SW[0] }} SW_3_0
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate {/DE1_SoC_tb/KEY[3]}
add wave -noupdate {/DE1_SoC_tb/KEY[0]}
add wave -noupdate {/DE1_SoC_tb/SW[9]}
add wave -noupdate /DE1_SoC_tb/SW_8_4
add wave -noupdate /DE1_SoC_tb/SW_3_0
add wave -noupdate /DE1_SoC_tb/HEX5
add wave -noupdate /DE1_SoC_tb/HEX4
add wave -noupdate /DE1_SoC_tb/HEX3
add wave -noupdate /DE1_SoC_tb/HEX2
add wave -noupdate /DE1_SoC_tb/HEX1
add wave -noupdate /DE1_SoC_tb/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 177
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
WaveRestoreZoom {0 ps} {974 ps}
