#------------------------------------------
# Parallel Algorithm by Yiheng Chi
#------------------------------------------

#----------------------------------------------------------
# First Processor - Consumer
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp0:
  push  $ra                 # save return address
  ori   $s0, $zero, 2     # main loop index, do 256 times
  ori   $s1, $zero, 0       # sum of 256 random numbers
p0loop:
  # pre-processing:
p0check: 
  # check the stack pointer
  ori   $t1, $zero, bsp     # obtain buffer stack pointer addr
  lw    $t0, 0($t1)         # obtain buffer stack pointer value
  slti  $t2, $t0, 0x800
  beq   $t2, $zero, p0check # no valid data in buffer stack
  # lock
  ori   $a0, $zero, lck     # move lock to arguement register
  jal   lock                # try to aquire the lock
  # consistency maintained
  jal   bufpop
  or    $s2, $zero, $v0
  # unlock
  ori   $a0, $zero, lck     # move lock to arguement register
  jal   unlock              # release the lock
  # post-processing: 1. crop lower 16b 2. add to sum, 3. update min and max
  andi  $s2, $s2, 0x0000FFFF # crop lower 16b
  add   $s1, $s1, $s2       # add to sum
  ori   $t1, $zero, resmax  # obtain result max addr
  lw    $a0, 0($t1)         # move result max value to argument register
  or    $a1, $zero, $s2     # move new random number to argument register
  jal   max
  sw    $v0, 0($t1)         # update result max
  ori   $t1, $zero, resmin  # obtain result min addr
  lw    $a0, 0($t1)         # move result min value to argument register
  jal   min
  sw    $v0, 0($t1)         # update result min
  # loop control
  addi  $s0, $s0, -1        # index <= index - 1
  bne   $s0, $zero, p0loop
  # calculate average
  or    $a0, $zero, $s1     # move sum to argument 
  ori   $a1, $zero, 256     # move denominator to argument
  jal   divide
  ori   $t1, $zero, resavg  # obtain result average addr
  sw    $v0, 0($t1)         # store result average
  # end of p0
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

lck:
  cfw 0x0
bsp:
  cfw 0x800

#----------------------------------------------------------
# Second Processor - producer
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address
  ori   $s0, $zero, 2     # main loop index, do 256 times
  ori   $s1, $zero, 0xBEEF  # initial seed
p1loop:
  # pre-processing: 1. get new random number
  or    $a0, $zero, $s1     # move previous random number to argument register
  jal   crc32
  or    $s1, $zero, $v0     # move new random number to register
p1check: 
  # check the stack pointer
  ori   $t1, $zero, bsp     # obtain buffer stack pointer addr
  lw    $t0, 0($t1)         # obtain buffer stack pointer value
  slti  $t2, $t0, 0x7dc
  bne   $t2, $zero, p1check # buffer stack full
  # lock
  ori   $a0, $zero, lck     # move lock to arguement register
  jal   lock                # try to aquire the lock
  # consistency maintained
  or    $a0, $zero, $s1     # move new random number to argument register
  jal   bufpsh
  # unlock
  ori   $a0, $zero, lck     # move lock to arguement register
  jal   unlock              # release the lock
  # post-processing:
  # loop control
  addi  $s0, $s0, -1        # index <= index - 1
  bne   $s0, $zero, p1loop
  # end of p1
  pop   $ra                 # get return address
  jr    $ra                 # return to caller


# Results
resavg:
  cfw 0x0                   # average of 256 random numbers
resmax:
  cfw 0x0                   # max of 256 random numbers
resmin:
  cfw 0xFFFF                # min of 256 random numbers

#----------------------------------------------------------
# Lock
#----------------------------------------------------------
# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

#----------------------------------------------------------
# Circular Buffer (stack)
#----------------------------------------------------------
# buffer push
# bufpsh($a0)
bufpsh:
  ori   $t1, $zero, bsp     # obtain buffer stack pointer addr
  lw    $t0, 0($t1)         # obtain buffer stack pointer value
  addi  $t0, $t0, -4        # decrement buffer stack pointer
  sw    $a0, 0($t0)         # store the top most stack element
  sw    $t0, 0($t1)         # store updated buffer stack pointer
  jr    $ra

# buffer pop
# bufpop returns ($v0) 
bufpop:
  ori   $t1, $zero, bsp     # obtain buffer stack pointer addr
  lw    $t0, 0($t1)         # obtain buffer stack pointer value
  lw    $v0, 0($t0)         # load the top most stack element
  sw    $zero, 0($t0)       # zero out the top most stack element
  addi  $t0, $t0, 4         # increment buffer stack pointer
  sw    $t0, 0($t1)         # store updated buffer stack pointer
  jr    $ra

#----------------------------------------------------------
# CRC
#
# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#----------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra

#----------------------------------------------------------
# Divide
#
# divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)
#----------------------------------------------------------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra

#----------------------------------------------------------
# Max
#
# max (a0=a,a1=b) returns v0=max(a,b)
#----------------------------------------------------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra

#----------------------------------------------------------
# Min
#
# min (a0=a,a1=b) returns v0=min(a,b)
#----------------------------------------------------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra

