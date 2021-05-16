.data
.include "paesq1.data"
.include "padir1.data"
.include "paesq2.data"
.include "padir2.data"
.include "paesq3.data"
.include "padir3.data"
.include "background.data"
.include "100mclaro.data"
.include "100rclaro.data"

.text

MAIN:
	jal BCKGRND
	jal PA_ESQ_1
	jal PA_DIR_1
	#jal PA_ESQ_2
	#jal PA_DIR_2
	#jal PA_ESQ_3
	#jal PA_DIR_3 
	jal PA_ESQ_1_CIMA
	jal PA_DIR_1_CIMA
	#jal PA_ESQ_2_CIMA
	#jal PA_DIR_2_CIMA
	#jal PA_ESQ_3_CIMA
	#jal PA_DIR_3_CIMA
	jal MARROM
	jal R_CIMA
	jal R_ESQUERDA
	jal APAGA_BOLA_1
	jal APAGA_BOLA_2
	jal APAGA_MOLA
	li a7,10
	ecall

BCKGRND:
	addi sp,sp,-4
	sw ra,0(sp)
	# Carrega a imagem1
FORA:	li t1,0xFF100000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF112C00	# endereco final 
	la s1,background	# endereço dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informações de nlin ncol
LOOP2: 	beq t1,t2,FIM		# Se for o último endereço então sai do loop
	lb t3,0(s1)		# le um conjunto de 4 pixels : word
	sb t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,1		# soma 4 ao endereço
	addi s1,s1,1
	j LOOP2			# volta a verificar

PA_ESQ_1:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,225		# x inicial da pa
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq1
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
LOOP1:	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PFIM
	addi a0,a0,1
	j LOOP1


PFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP1

FIM:	
	#lw ra,0(sp)
	#addi sp,sp,4
	ret
	
PA_ESQ_2:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,225		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq2
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_ESQ_3:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,225		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq3
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1




PA_DIR_1:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,225		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir1
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_DIR_2:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,225		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir2
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_DIR_3:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,217		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,225		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir3
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_ESQ_1_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq1
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1

PA_ESQ_2_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq2
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1

PA_ESQ_3_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,35		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,64		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,paesq3
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_DIR_1_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir1
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_DIR_2_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir2
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
PA_DIR_3_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,85		# x inicial da pa 
	li a1,100		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,114		# x final da pa
	li a3,108		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,padir3
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP1
	
MARROM:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,65		# x inicial da pa 
	li a1,172		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,83		# x final da pa
	li a3,184		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,mclaro
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP3
	
R_CIMA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,65		# x inicial da pa 
	li a1,43		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,83		# x final da pa
	li a3,55		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,rclaro
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP3
	
R_DIREITA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,89		# x inicial da pa 
	li a1,155		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,107		# x final da pa
	li a3,167		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,rclaro
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP3

R_ESQUERDA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,41		# x inicial da pa 
	li a1,155		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,59		# x final da pa
	li a3,167		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,rclaro
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
	j LOOP3

LOOP3:	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,CFIM
	addi a0,a0,1
	j LOOP3
	
CFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-18
	li t2,0
	j LOOP3
	
	
APAGA_BOLA_1:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,228		# x inicial da pa 
	li a1,115		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,242		# x final da pa
	li a3,129		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	li t0,15		# carrega colunas
	li t1,15		# carrega linhas
	li t2,0
	li t3,0
LOOP_APAGA_BOLA:
	sb t3,0(a0)
	addi t2,t2,1
	beq t2,t0,BFIM
	addi a0,a0,1
	j LOOP_APAGA_BOLA
	
BFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-14
	li t2,0
	j LOOP_APAGA_BOLA
	
APAGA_BOLA_2:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,246		# x inicial da pa 
	li a1,115		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,260		# x final da pa
	li a3,129		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	li t0,15		# carrega colunas
	li t1,15		# carrega linhas
	li t2,0
	li t3,0
	j LOOP_APAGA_BOLA
	
APAGA_BOLA_3:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,264		# x inicial da pa 
	li a1,115		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,278		# x final da pa
	li a3,129		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	li t0,15		# carrega colunas
	li t1,15		# carrega linhas
	li t2,0
	li t3,0
	j LOOP_APAGA_BOLA
	
APAGA_MOLA:
	addi sp,sp,-4
	sw ra,0(sp)
	li t0,0xFF100000	# endereco inicial bitmap 
	li a0,150		# x inicial da pa 
	li a1,203		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,160		# x final da pa
	li a3,215		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	li t0,11		# carrega colunas
	li t1,13		# carrega linhas
	li t2,0
	li t3,0
LOOP_MOLA:
	sb t3,0(a0)
	addi t2,t2,1
	beq t2,t0,MFIM
	addi a0,a0,1
	j LOOP_MOLA

MFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-10
	li t2,0
	j LOOP_MOLA
	
	