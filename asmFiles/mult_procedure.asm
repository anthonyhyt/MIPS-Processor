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

  # start of while loop
  # exit if no operand on stack
  ori     $11, $0, 0xFFFC
  beq     $29, $11, Exit
  # exit if 1 operand on stack
  ori     $11, $0, 0xFFF8
  beq     $29, $11, Exit
Loop:
  jal     Multiply
  bne     $29, $11, Loop
Exit:
  halt

  # multiply subroutine
Multiply:
  # $8 - result, $9 & $10 - operands
  ori     $8, $0, 0x0000
  pop     $9
  pop     $10

  # start of while loop
  beq     $10, $0, Mult_Exit
Mult_Loop:
  addu    $8, $8, $9
  addi    $10, $10, -1
  bne     $10, $0, Mult_Loop
Mult_Exit:
  push    $8
  jr      $31
