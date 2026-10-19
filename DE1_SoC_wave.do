onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs {/DE1_SoC_testbench/SW[9]}
add wave -noupdate -expand -group Inputs {/DE1_SoC_testbench/SW[8]}
add wave -noupdate -expand -group Inputs {/DE1_SoC_testbench/SW[7]}
add wave -noupdate -expand -group Inputs {/DE1_SoC_testbench/SW[0]}
add wave -noupdate -expand -group Outputs {/DE1_SoC_testbench/LEDR[1]}
add wave -noupdate -expand -group Outputs {/DE1_SoC_testbench/LEDR[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 243
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
WaveRestoreZoom {0 ps} {2134 ps}
