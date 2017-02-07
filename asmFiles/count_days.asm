#
# Yiheng Chi
# chi14@purdue.edu
#
# count number of days since year 2000
#

  org     0x0000

  ori     $29, $0, 0xFFFC

  # $12 - total days
  ori     $12, $0, 0

  # diff in year
  ori     $11, $0, CurrentYear
  lw      $11, 0($11)
  addi    $11, $11, -2000
  push    $11
  # x365 days
  ori     $11, $0, 365
  push    $11
  # multiply & count in total
  jal     Multiply
  pop     $11
  addu    $12, $12, $11

  # diff in month
  ori     $11, $0, CurrentMonth
  lw      $11, 0($11)
  addi    $11, $11, -1
  push    $11
  # x30 days
  ori     $11, $0, 30
  push    $11
  # multiply & count in total
  jal     Multiply
  pop     $11
  addu    $12, $12, $11

  # count days in total
  ori     $11, $0, CurrentDay
  lw      $11, 0($11)
  addu    $12, $12, $11

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

  # variables
  org     0x0200
CurrentDay:
  #org     0x0200
  cfw     6
CurrentMonth:
  #org     0x0204
  cfw     1
CurrentYear:
  #org     0x0208
  cfw     2017
