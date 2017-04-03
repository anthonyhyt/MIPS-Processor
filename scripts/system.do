onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/RAM/addr
add wave -noupdate /system_tb/DUT/CPU/CC/CC/state
add wave -noupdate /system_tb/DUT/CPU/CC/CC/iserve
add wave -noupdate /system_tb/DUT/CPU/CC/CC/iserve_w
add wave -noupdate /system_tb/DUT/CPU/CC/CC/dserve
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -expand -group ram /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -group DP0 /system_tb/DUT/CPU/CM0/cif/iaddr
add wave -noupdate -group DP0 /system_tb/DUT/CPU/CM0/cif/iREN
add wave -noupdate -group DP0 /system_tb/DUT/CPU/CM0/cif/iwait
add wave -noupdate -group DP0 /system_tb/DUT/CPU/CM0/ICACHE/cache
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/PC/pcif/pci
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/PC/pcif/pco
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/REF/regs
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/rti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/iti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/jti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/exrti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/exiti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/exjti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/mmrti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/mmiti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/mmjti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/wbrti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/wbiti
add wave -noupdate -group DP0 /system_tb/DUT/CPU/DP0/wbjti
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/DCU/state
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/addr
add wave -noupdate -group CM0 -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/dcbuf[0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/dcbuf
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/msi
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/dcif/dmemREN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/dcif/dmemWEN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/ind
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/waysel
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/blksel
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/ccing
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/ccend
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/pccwait
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/ccwait
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/ccinv
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/ccwrite
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/cctrans
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/ccsnoopaddr
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/dREN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/dWEN
add wave -noupdate -group CM0 /system_tb/DUT/CPU/CM0/DCACHE/cif/dwait
add wave -noupdate -group DP1 /system_tb/DUT/CPU/CM1/cif/iaddr
add wave -noupdate -group DP1 /system_tb/DUT/CPU/CM1/cif/iREN
add wave -noupdate -group DP1 /system_tb/DUT/CPU/CM1/cif/iwait
add wave -noupdate -group DP1 /system_tb/DUT/CPU/CM1/ICACHE/cache
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/PC/pcif/pci
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/PC/pcif/pco
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/REF/regs
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/rti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/iti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/jti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/exrti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/exiti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/exjti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/mmrti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/mmiti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/mmjti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/wbrti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/wbiti
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/wbjti
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/DCU/state
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/addr
add wave -noupdate -group CM1 -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/dcbuf[1]} -expand {/system_tb/DUT/CPU/CM1/DCACHE/dcbuf[0]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/dcbuf
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/msi
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/dcif/dmemREN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/dcif/dmemWEN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/ind
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/waysel
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/blksel
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/ccing
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/ccend
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/pccwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccinv
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccwrite
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/cif/cctrans
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccsnoopaddr
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dload
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dREN
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dwait
add wave -noupdate -group CM1 /system_tb/DUT/CPU/CM1/cif/dWEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1147005 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 169
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
WaveRestoreZoom {792316 ps} {1672316 ps}
