addi a1,zero,1    # a1 = 1
addi a3,zero,2    # a3 = 2
addi t1,zero,3    # t1 = 3
add a3,a1,a3    # a3 = 3
beq t1,a3,12    # verifica add
addi a0,zero,-1 # errado
jal ra,0    #
jal ra,176    # certo
and t1,a1,a3    # 00....001 && 00....011 = 00....001 = t1
beq t1,a1,12     # verifica and
addi a0,zero,-1 # errado
jal ra,0    #
jal ra,156    # certo
or t1,a1,a3    # 00....001 || 00....011 = 00....011 = t1
beq t1,a3,12     # verifica or
addi a0,zero,-1 # errado
jal ra,0    #
jal ra,136    # certo
slt t1,a1,a3     # 00....001 < 00....011 = t1
beq t1,a1,12    # verifica slt
addi a0,zero,-1 # errado
jal ra,0    #
jal ra,116    # certo
xor t1,a1,a3    # 00...001 xor 00....011 = t1
addi t2,zero,2    # t2 = 2
beq t1,t2,12     # verifica xor
addi a0,zero,-1 # errado
jal ra,0    #
jal ra,92    # certo
lui t1,2        # t2 = 00000000000000000010000000000000
addi t2,zero,1024;     # t2 = 1024
add t2,t2,t2         # t2 = t2 + t2 = 2048
add t2,t2,t2        # t2 = 4096
add t2,t2,t2        # t2 = 8192
beq t1,t2,12        # verifica lui
addi a0,zero,-1        # errado
jal ra,0        #
jal ra,56        # certo
sw a1,0(zero)    
lw a2,0(zero)
beq a2,a1,12     # verifica sw e lw
addi a0,zero,-1    # errado
jal ra,0    #
jal ra,32    # certo
slli t1,a1,1
addi t2,zero,2
beq t1,t2,CERTO 	# verifica slli
addi a0,zero,-1		# errado
jal ra,0			#
jal ra,8			# certo
jal ra,24     # fim
lui a0,-209716        #
addi t3,zero,1638    # Escreve CCCCCCCC
add t3,t3,t3        #
add a0,a0,t3        #
jalr zero,ra,0
lui a0,-209716
addi t3,zero,1638	#final
add t3,t3,t3
add a0,a0,t3
jal t0,0