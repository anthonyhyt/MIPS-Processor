#
# Yiheng Chi
# chi14@purdue.edu
#
# test unused command slti and sltiu
#

org     0x0000

ori     $21, $0, 0x80
ori     $8, $0, 0xFFF0
ori     $9, $0, 0xFFFF
slt     $10, $8, $9
sltu    $11, $8, $9
slti    $12, $8, 0xFF
sltiu   $13, $8, 0xFF

sw      $8, 0($21)
sw      $9, 4($21)
sw      $10, 8($21)
sw      $11, 12($21)
sw      $12, 16($21)
sw      $13, 20($21)
halt

