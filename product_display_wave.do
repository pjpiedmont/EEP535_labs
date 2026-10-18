onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /product_display_testbench/u
add wave -noupdate /product_display_testbench/p
add wave -noupdate /product_display_testbench/c
add wave -noupdate /product_display_testbench/dut/product_name
add wave -noupdate /product_display_testbench/dut/char0
add wave -noupdate /product_display_testbench/dut/char1
add wave -noupdate /product_display_testbench/dut/char2
add wave -noupdate /product_display_testbench/dut/char3
add wave -noupdate /product_display_testbench/dut/char4
add wave -noupdate /product_display_testbench/dut/char5
add wave -noupdate /product_display_testbench/leds0
add wave -noupdate /product_display_testbench/leds1
add wave -noupdate /product_display_testbench/leds2
add wave -noupdate /product_display_testbench/leds3
add wave -noupdate /product_display_testbench/leds4
add wave -noupdate /product_display_testbench/leds5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
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
WaveRestoreZoom {0 ps} {162 ps}
