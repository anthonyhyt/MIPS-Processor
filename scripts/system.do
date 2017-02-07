onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pci
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pco
add wave -noupdate -expand /system_tb/DUT/CPU/DP/rti
add wave -noupdate /system_tb/DUT/CPU/DP/iti
add wave -noupdate -expand /system_tb/DUT/CPU/DP/jti
add wave -noupdate -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/DP/REF/regs[31]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[30]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[29]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[28]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[27]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[26]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[25]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[24]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[23]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[22]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[21]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[20]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[19]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[18]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[17]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[16]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[15]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[14]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[13]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[12]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[11]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[10]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[9]} -radix decimal} {{/system_tb/DUT/CPU/DP/REF/regs[8]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[7]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[6]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/REF/regs[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/REF/regs[31]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[30]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[29]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[28]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[27]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[26]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[25]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[24]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[23]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[22]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[21]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[20]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[19]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[18]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[17]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[16]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[15]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[14]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[13]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[12]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[11]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[10]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[9]} {-height 17 -radix decimal} {/system_tb/DUT/CPU/DP/REF/regs[8]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[7]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[6]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/REF/regs[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/DP/REF/regs
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/opfunc
add wave -noupdate /system_tb/DUT/CPU/DP/equal
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_negative
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_overflow
add wave -noupdate /system_tb/DUT/CPU/DP/aif/flag_zero
add wave -noupdate /system_tb/DUT/CPU/DP/aif/aluop
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/aif/port_o
add wave -noupdate -expand -group ifif /system_tb/DUT/CPU/DP/ifif/flush
add wave -noupdate -expand -group ifif /system_tb/DUT/CPU/DP/ifif/en
add wave -noupdate -expand -group ifif /system_tb/DUT/CPU/DP/ifif/instr
add wave -noupdate -expand -group ifif /system_tb/DUT/CPU/DP/ifif/npc
add wave -noupdate -group id1if /system_tb/DUT/CPU/DP/id1if/instr
add wave -noupdate -group id1if /system_tb/DUT/CPU/DP/id1if/npc
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/opfunc
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/RegDst
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/MemtoReg
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/ALUSrc
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/RegWEN
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/dWENi
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/dRENi
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/ALUOp
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/ExtOp
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/halt
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/rt
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/rd
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/shamt
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/imm
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/busA
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/busB
add wave -noupdate -group id2if /system_tb/DUT/CPU/DP/id2if/npc
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/opfunc
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/RegDst
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/MemtoReg
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/ALUSrc
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/RegWEN
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/dWENi
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/dRENi
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/ALUOp
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/ExtOp
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/halt
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/rt
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/rd
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/shamt
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/imm
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/busA
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/busB
add wave -noupdate -expand -group ex1if /system_tb/DUT/CPU/DP/ex1if/npc
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/opfunc
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/MemtoReg
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/RegWEN
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/dWENi
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/dRENi
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/equal
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/halt
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/en
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/rd
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/portB
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/npc
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/ALUOut
add wave -noupdate -expand -group ex2if /system_tb/DUT/CPU/DP/ex2if/store
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/opfunc
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/MemtoReg
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/RegWEN
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/dWENi
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/dRENi
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/equal
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/halt
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/rd
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/portB
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/npc
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/ALUOut
add wave -noupdate -expand -group mm1if /system_tb/DUT/CPU/DP/mm1if/store
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/opfunc
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/MemtoReg
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/RegWEN
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/equal
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/halt
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/rd
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/portB
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/npc
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/ALUOut
add wave -noupdate -group mm2if /system_tb/DUT/CPU/DP/mm2if/load
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/opfunc
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/MemtoReg
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/RegWEN
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/equal
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/halt
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/rd
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/portB
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/npc
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/ALUOut
add wave -noupdate -group wbif /system_tb/DUT/CPU/DP/wbif/load
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {383942 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 142
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
WaveRestoreZoom {0 ps} {1210 ns}
