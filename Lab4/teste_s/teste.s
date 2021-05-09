.eqv N 32

.data
#Vetor:  .word 9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31,4,-4

.text	
MAIN:	jal INICIALIZA

	mv a0,zero
	li a1,N
	jal SORT

	mv a0,zero
	li a1,N
	jal SHOW

FIM:	j FIM


SWAP:	slli t1,a1,2
	add t1,a0,t1
	lw t0,0(t1)
	lw t2,4(t1)
	sw t2,0(t1)
	sw t0,4(t1)
	ret

SORT:	addi sp,sp,-20
	sw ra,16(sp)
	sw s3,12(sp)
	sw s2,8(sp)
	sw s1,4(sp)
	sw s0,0(sp)
	mv s2,a0
	mv s3,a1
	mv s0,zero
for1:	slt t6,s0,s3
	beq t6,zero,exit1
	addi s1,s0,-1
for2:	slt t6,s1,zero
	li tp,1
	beq t6,tp,exit2
	slli t1,s1,2
	add t2,s2,t1
	lw t3,0(t2)
	lw t4,4(t2)
	slt t6,t4,t3
	beq t6,zero,exit2
	mv a0,s2
	mv a1,s1
	jal SWAP
	addi s1,s1,-1
	j for2
exit2:	addi s0,s0,1
	j for1
exit1: 	lw s0,0(sp)
	lw s1,4(sp)
	lw s2,8(sp)
	lw s3,12(sp)
	lw ra,16(sp)
	addi sp,sp,20
	ret

SHOW:	mv t0,a0
	mv t1,a1
	mv t2,zero

loop1: 	beq t2,t1,fim1
	lw a0,0(t0)
	addi t0,t0,4
	addi t2,t2,1
	j loop1
fim1:	ret


INICIALIZA:       # Inicializa a RAM de dados com o vetor a apartir do endereço 0x00000000
#Vetor:  .word 9,2,5,1,8,2,4,3,
	li a0,9
	sw a0,0(zero)
	li a0,2
	sw a0,4(zero)	
	li a0,5
	sw a0,8(zero)
	li a0,1
	sw a0,12(zero)	
	li a0,8
	sw a0,16(zero)
	li a0,2
	sw a0,20(zero)	
	li a0,4
	sw a0,24(zero)
	li a0,3
	sw a0,28(zero)	
	#Vetor:  .word 6,7,10,2,32,54,2,12,
	li a0,6
	sw a0,32(zero)
	li a0,7
	sw a0,36(zero)	
	li a0,10
	sw a0,40(zero)
	li a0,2
	sw a0,44(zero)	
	li a0,32
	sw a0,48(zero)
	li a0,54
	sw a0,52(zero)	
	li a0,2
	sw a0,56(zero)
	li a0,12
	sw a0,60(zero)	
	
	#Vetor:  .word 6,3,1,78,54,23,1,54
	li a0,6
	sw a0,64(zero)
	li a0,3
	sw a0,68(zero)	
	li a0,1
	sw a0,72(zero)
	li a0,78
	sw a0,76(zero)	
	li a0,54
	sw a0,80(zero)
	li a0,23
	sw a0,84(zero)	
	li a0,1
	sw a0,88(zero)
	li a0,54
	sw a0,92(zero)	

	#Vetor:  .word 2,65,3,6,55,31,4,-4
	li a0,2
	sw a0,96(zero)
	li a0,65
	sw a0,100(zero)	
	li a0,3
	sw a0,104(zero)
	li a0,6
	sw a0,108(zero)	
	li a0,55
	sw a0,112(zero)
	li a0,31
	sw a0,116(zero)	
	li a0,4
	sw a0,120(zero)
	li a0,-4
	sw a0,124(zero)	

	ret