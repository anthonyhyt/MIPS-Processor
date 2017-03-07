onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/DUT/DCU/state
add wave -noupdate /dcache_tb/DUT/DCU/dmemREN
add wave -noupdate /dcache_tb/DUT/DCU/dmemWEN
add wave -noupdate /dcache_tb/DUT/DCU/dhit
add wave -noupdate /dcache_tb/DUT/DCU/dwait
add wave -noupdate /dcache_tb/DUT/DCU/dirty
add wave -noupdate /dcache_tb/DUT/DCU/flush
add wave -noupdate /dcache_tb/DUT/dhit
add wave -noupdate /dcache_tb/DUT/dhit0
add wave -noupdate /dcache_tb/DUT/dhit1
add wave -noupdate /dcache_tb/DUT/dcbuf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {204 ns} 0}
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
WaveRestoreZoom {0 ns} {525 ns}