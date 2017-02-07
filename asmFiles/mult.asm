#
# Yiheng Chi
# chi14@purdue.edu
#
# multiply two unsigned words in stack
#

  org     0x0000

  ori     $29, $0, 0xFFFC

  # test: 3 x 6 = ?
  ori     $11, $0, 0x0003
  push    $11
  ori     $11, $0, 0x0006
  push    $11

  # $8 - result, $9 & $10 - operands
  ori     $8, $0, 0x0000
  pop     $9
  pop     $10

  # start of while loop
  beq     $10, $0, Exit
Loop:
  addu    $8, $8, $9
  addi    $10, $10, -1
  bne     $10, $0, Loop
Exit:
  halt

