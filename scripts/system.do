onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pci
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pco
add wave -noupdate -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/DP/REF/regs[31]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[30]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[29]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[28]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[27]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[26]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[25]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[24]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[23]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[22]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[21]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[20]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[19]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[18]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[17]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[16]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[15]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[14]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[13]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[12]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[11]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[10]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[9]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[8]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[7]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[6]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/REF/regs[31]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[30]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[29]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[28]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[27]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[26]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[25]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[24]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[23]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[22]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[21]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[20]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[19]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[18]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[17]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[16]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[15]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[14]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[13]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[12]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[11]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[10]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[9]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[8]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[7]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[6]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/DP/REF/regs
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/rti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/iti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/jti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/exrti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/exiti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/exjti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/mmrti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/mmiti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/mmjti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/wbrti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/wbiti
add wave -noupdate -group {instr in pipe} /system_tb/DUT/CPU/DP/wbjti
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/opfunc
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/MemtoReg
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/RegWEN
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/dWENi
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/dRENi
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/equal
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/halt
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/rd
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/portB
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/npc
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/EXMM/mmif/bpc
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/ALUOut
add wave -noupdate -group mm1if /system_tb/DUT/CPU/DP/mm1if/store
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/MMWB/mmif/en
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/MemtoReg
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/RegWEN
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/equal
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/halt
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/rd
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/portB
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/npc
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/ALUOut
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/load
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -group dcif /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group cif /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/DCU/state
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/flctclr
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/hitctup
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/hitctdn
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/flctup
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/hitctout
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/hitnum
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/flnum
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/flushing
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/cublof
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dhit
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dhit0
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dhit1
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dhitidle
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dirty
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dirties
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/invalid
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/ind
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/waysel
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/blksel
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/srcsel
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/cacheWEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/tomem
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/cacheout
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/memaddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/cacheaddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dpaddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/alldirties
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dcbuf
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/lru
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1678443046 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {1677641500 ps} {1679907323 ps}
