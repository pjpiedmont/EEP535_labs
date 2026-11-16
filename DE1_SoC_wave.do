onerror {resume}
quietly virtual function -install /DE1_SoC_tb -env /DE1_SoC_tb/#INITIAL#68(#ublk#78061266#68) { &{/DE1_SoC_tb/SW[7], /DE1_SoC_tb/SW[6], /DE1_SoC_tb/SW[5], /DE1_SoC_tb/SW[4], /DE1_SoC_tb/SW[3], /DE1_SoC_tb/SW[2], /DE1_SoC_tb/SW[1], /DE1_SoC_tb/SW[0] }} SW_7_0
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate {/DE1_SoC_tb/KEY[0]}
add wave -noupdate {/DE1_SoC_tb/SW[9]}
add wave -noupdate /DE1_SoC_tb/SW_7_0
add wave -noupdate {/DE1_SoC_tb/LEDR[9]}
add wave -noupdate /DE1_SoC_tb/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6256 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {9852 ps}
