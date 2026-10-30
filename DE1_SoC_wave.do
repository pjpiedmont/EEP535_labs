onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK_50 /DE1_SoC_testbench/CLOCK_50
add wave -noupdate -label {SW[9] (reset)} {/DE1_SoC_testbench/SW[9]}
add wave -noupdate -label {SW[0] (w)} {/DE1_SoC_testbench/SW[0]}
add wave -noupdate -label {LEDR[0] (out)} {/DE1_SoC_testbench/LEDR[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {19705 ps}
