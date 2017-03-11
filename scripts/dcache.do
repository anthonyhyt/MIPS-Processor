onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/DUT/CLK
add wave -noupdate /dcache_tb/DUT/nRST
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/DCU/state
add wave -noupdate -expand -group {state machine} /dcache_tb/DUT/DCU/dirty
add wave -noupdate -expand -group counter /dcache_tb/DUT/clr_ct_clr
add wave -noupdate -expand -group counter /dcache_tb/DUT/hit_ctup
add wave -noupdate -expand -group counter /dcache_tb/DUT/hit_ctdown
add wave -noupdate -expand -group counter /dcache_tb/DUT/clr_ct_en
add wave -noupdate -expand -group counter /dcache_tb/DUT/hit_ct_o_en
add wave -noupdate -expand -group counter /dcache_tb/DUT/hit_num
add wave -noupdate -expand -group counter /dcache_tb/DUT/clr_num
add wave -noupdate /dcache_tb/DUT/block_offset_cu
add wave -noupdate /dcache_tb/DUT/dhit
add wave -noupdate /dcache_tb/DUT/dhit0
add wave -noupdate /dcache_tb/DUT/dhit1
add wave -noupdate /dcache_tb/DUT/dirty0
add wave -noupdate /dcache_tb/DUT/dirty1
add wave -noupdate /dcache_tb/DUT/dirties
add wave -noupdate /dcache_tb/DUT/alldirties
add wave -noupdate /dcache_tb/DUT/datatocache
add wave -noupdate /dcache_tb/DUT/index
add wave -noupdate /dcache_tb/DUT/cacheWEN
add wave -noupdate /dcache_tb/DUT/wayselect
add wave -noupdate /dcache_tb/DUT/blockselect
add wave -noupdate /dcache_tb/DUT/tomem
add wave -noupdate /dcache_tb/DUT/cacheout
add wave -noupdate /dcache_tb/DUT/memaddr
add wave -noupdate /dcache_tb/DUT/cacheaddr
add wave -noupdate -expand -subitemconfig {{/dcache_tb/DUT/dcbuf[1]} -expand {/dcache_tb/DUT/dcbuf[1][0]} -expand {/dcache_tb/DUT/dcbuf[0]} -expand {/dcache_tb/DUT/dcbuf[0][1]} -expand {/dcache_tb/DUT/dcbuf[0][0]} -expand} /dcache_tb/DUT/dcbuf
add wave -noupdate /dcache_tb/DUT/lru
add wave -noupdate -expand /dcache_tb/DUT/addr
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/halt
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dhit
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dmemREN
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dmemWEN
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/flushed
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dmemload
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dmemstore
add wave -noupdate -group dcif /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dwait
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dREN
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dWEN
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dload
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/dstore
add wave -noupdate -expand -group cif /dcache_tb/DUT/cif/daddr
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
WaveRestoreZoom {0 ns} {570 ns}
