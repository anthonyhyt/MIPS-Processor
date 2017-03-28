onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /coherence_control_tb/CLK
add wave -noupdate /coherence_control_tb/RAM_CLK
add wave -noupdate /coherence_control_tb/nRST
add wave -noupdate /coherence_control_tb/PROG/testcases
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/iwait}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/dwait}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/iREN}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/dREN}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/dWEN}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/iload}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/dload}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/dstore}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/iaddr}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/daddr}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/ccwait}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/ccinv}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/ccwrite}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/cctrans}
add wave -noupdate -group cif1 {/coherence_control_tb/PROG/cif[1]/ccsnoopaddr}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/iwait}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/dwait}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/iREN}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/dREN}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/dWEN}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/iload}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/dload}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/dstore}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/iaddr}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/daddr}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/ccwait}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/ccinv}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/ccwrite}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/cctrans}
add wave -noupdate -group cif0 {/coherence_control_tb/PROG/cif[0]/ccsnoopaddr}
add wave -noupdate -expand /coherence_control_tb/PROG/core
add wave -noupdate /coherence_control_tb/PROG/working
add wave -noupdate /coherence_control_tb/PROG/readOrWrite1
add wave -noupdate /coherence_control_tb/PROG/readOrWrite2
add wave -noupdate /coherence_control_tb/PROG/dload1
add wave -noupdate /coherence_control_tb/PROG/dload2
add wave -noupdate /coherence_control_tb/PROG/iload1
add wave -noupdate /coherence_control_tb/PROG/iload2
add wave -noupdate /coherence_control_tb/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {358668 ps} 0}
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
WaveRestoreZoom {0 ps} {735 ns}
