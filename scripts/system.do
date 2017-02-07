onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pci
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pco
add wave -noupdate -expand /system_tb/DUT/CPU/DP/rti
add wave -noupdate -expand /system_tb/DUT/CPU/DP/iti
add wave -noupdate -expand /system_tb/DUT/CPU/DP/jti
add wave -noupdate -radix decimal -childformat {{{/system_tb/DUT/CPU/DP/REF/regs[31]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[30]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[29]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[28]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[27]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[26]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[25]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[24]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[23]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[22]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[21]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[20]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[19]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[18]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[17]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[16]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[15]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[14]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[13]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[12]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[11]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[10]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[9]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[8]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[7]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[6]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[5]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[4]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[3]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[2]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[1]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[0]} -radix decimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/REF/regs[31]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[30]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[29]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[28]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[27]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[26]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[25]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[24]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[23]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[22]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[21]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[20]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[19]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[18]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[17]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[16]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[15]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[14]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[13]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[12]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[11]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[10]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[9]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[8]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[7]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[6]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[5]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[4]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[3]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[2]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[1]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[0]} {-height 17 -radix decimal}} /system_tb/DUT/CPU/DP/REF/regs
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/opfunc
add wave -noupdate /system_tb/DUT/CPU/DP/equal
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_negative
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_overflow
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_zero
add wave -noupdate /system_tb/DUT/CPU/DP/aif/aluop
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_o
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/ruif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {274508 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1470 ns}
