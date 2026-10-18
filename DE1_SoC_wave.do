onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs -height 30 {/DE1_SoC_testbench/SW[9]}
add wave -noupdate -expand -group Inputs -height 30 {/DE1_SoC_testbench/SW[8]}
add wave -noupdate -expand -group Inputs -height 30 {/DE1_SoC_testbench/SW[7]}
add wave -noupdate -expand -group Inputs -height 30 {/DE1_SoC_testbench/SW[0]}
add wave -noupdate -expand -group Outputs -height 30 {/DE1_SoC_testbench/LEDR[1]}
add wave -noupdate -expand -group Outputs -height 30 {/DE1_SoC_testbench/LEDR[0]}
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX0
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX1
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX2
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX3
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX4
add wave -noupdate -expand -group Outputs -height 30 /DE1_SoC_testbench/HEX5
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/u
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/p
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/c
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/product_name
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char0
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char1
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char2
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char3
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char4
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/char5
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds0
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds1
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds2
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds3
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds4
add wave -noupdate -expand -group {Internal - UPC Display} -height 30 /DE1_SoC_testbench/dut/disp/leds5
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/u
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/p
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/c
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/isMarkPresent
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/isStolen
add wave -noupdate -expand -group {Internal - Stolen Detector} -height 30 /DE1_SoC_testbench/dut/detector/isDiscounted
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {178 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 319
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
WaveRestoreZoom {0 ps} {336 ps}
