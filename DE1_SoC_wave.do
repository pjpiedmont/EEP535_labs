onerror {resume}
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[7], /DE1_SoC_testbench/SW[6], /DE1_SoC_testbench/SW[5], /DE1_SoC_testbench/SW[4] }} Digit1
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[3], /DE1_SoC_testbench/SW[2], /DE1_SoC_testbench/SW[1], /DE1_SoC_testbench/SW[0] }} digit0
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[7], /DE1_SoC_testbench/SW[6], /DE1_SoC_testbench/SW[5], /DE1_SoC_testbench/SW[4] }} digit1
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs -radix unsigned -childformat {{(3) -radix unsigned} {(2) -radix unsigned} {(1) -radix unsigned} {(0) -radix unsigned}} -expand -subitemconfig {{/DE1_SoC_testbench/SW[7]} {-radix unsigned} {/DE1_SoC_testbench/SW[6]} {-radix unsigned} {/DE1_SoC_testbench/SW[5]} {-radix unsigned} {/DE1_SoC_testbench/SW[4]} {-radix unsigned}} /DE1_SoC_testbench/digit1
add wave -noupdate -expand -group Inputs -radix unsigned -childformat {{(3) -radix unsigned} {(2) -radix unsigned} {(1) -radix unsigned} {(0) -radix unsigned}} -expand -subitemconfig {{/DE1_SoC_testbench/SW[3]} {-radix unsigned} {/DE1_SoC_testbench/SW[2]} {-radix unsigned} {/DE1_SoC_testbench/SW[1]} {-radix unsigned} {/DE1_SoC_testbench/SW[0]} {-radix unsigned}} /DE1_SoC_testbench/digit0
add wave -noupdate -expand -group Internal -radix unsigned /DE1_SoC_testbench/dut/digit1
add wave -noupdate -expand -group Internal -radix unsigned /DE1_SoC_testbench/dut/digit0
add wave -noupdate -expand -group Internal /DE1_SoC_testbench/dut/digit1IsEqual
add wave -noupdate -expand -group Internal /DE1_SoC_testbench/dut/digit0IsEqual
add wave -noupdate -expand -group Outputs {/DE1_SoC_testbench/LEDR[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1510 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 259
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
WaveRestoreZoom {565 ps} {2665 ps}
