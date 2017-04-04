onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/DUT/CLK
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/DCU/state
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/DCU/dirty
add wave -noupdate /dcache_tb/DUT/dhit
add wave -noupdate /dcache_tb/DUT/dhit0
add wave -noupdate /dcache_tb/DUT/dhit1
add wave -noupdate /dcache_tb/DUT/cacheWEN
add wave -noupdate /dcache_tb/DUT/cacheaddr
add wave -noupdate {/dcache_tb/DUT/dcbuf[0][1]}
add wave -noupdate {/dcache_tb/DUT/dcbuf[0][0]}
add wave -noupdate /dcache_tb/DUT/msi
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dhit
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dmemREN
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dmemWEN
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dmemload
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dmemstore
add wave -noupdate -expand -group dcif /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dwait
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dREN
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dWEN
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dload
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dstore
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/daddr
add wave -noupdate /dcache_tb/c/ccwait
add wave -noupdate /dcache_tb/c/ccinv
add wave -noupdate /dcache_tb/c/ccwrite
add wave -noupdate /dcache_tb/c/cctrans
add wave -noupdate /dcache_tb/c/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {235 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 252
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
WaveRestoreZoom {0 ns} {1055 ns}
