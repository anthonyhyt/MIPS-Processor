  org 0x0000
  ori $1, $0, 0xffff
  push $1
  pop $2
  sw $1, 40($0)
  sw $2, 44($0)
  halt
