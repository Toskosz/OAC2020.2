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
.include "start.data"
.text

MAIN:
	#jal TRANSPARENTE
	jal BCKGRND
	jal START
	jal PA_ESQ_1
	jal PA_DIR_1
	jal PA_ESQ_1_CIMA
	jal PA_DIR_1_CIMA
	jal KEY1
	jal APAGA_START
	li s0,113	# q
	li s1,101	# e
	li s2,97	# a
	li s3,100	# d
	jal COMANDO
	li a7,10
	ecall

COMANDO: 	
	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
LOOP_COMANDO: 	
	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP_COMANDO	# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
  	sw t2,12(t1)  			# escreve a tecla pressionada no display
  	addi sp,sp,-20
  	sw t2,16(sp)
	sw s3,12(sp)
	sw s2,8(sp)
	sw s1,4(sp)
	sw s0,0(sp)
  	beq t2,s2,PA_ESQ_2
  	jal PA_ESQ_1
A:  	lw t2,16(sp)
	lw s3,12(sp)
  	beq t2,s3,PA_DIR_2
  	jal PA_DIR_1
B:  	lw t2,16(sp)
	lw s0,0(sp)
  	beq t2,s0,PA_ESQ_2_CIMA
  	jal PA_ESQ_1_CIMA
C:  	lw t2,16(sp)
	lw s1,4(sp)
  	beq t2,s1,PA_DIR_2_CIMA
  	jal PA_DIR_1_CIMA
D:  	addi sp,sp,20
	j COMANDO			# retorna
	
### Espera o usuário pressionar uma tecla
KEY1: 	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
LOOP: 	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
  	sw t2,12(t1)  			# escreve a tecla pressionada no display
	ret				# retorna

BCKGRND:
	# Carrega a imagem1
FORA:	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,background	# endereço dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informações de nlin ncol
LOOP2: 	beq t1,t2,FIM		# Se for o último endereço então sai do loop
	lb t3,0(s1)		# le um conjunto de 4 pixels : word
	sb t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,1		# soma 4 ao endereço
	addi s1,s1,1
	j LOOP2			# volta a verificar

PA_ESQ_1:
	li t0,0xFF000000	# endereco inicial bitmap 
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
	ret
	
PA_ESQ_2:
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAE_2:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PAEFIM_2
	addi a0,a0,1
	j LOOP_PAE_2
	
PAEFIM_2:
	beq a0,a2,PA_ESQ_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAE_2
	
PA_ESQ_3:
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAE_3:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PAEFIM_3
	addi a0,a0,1
	j LOOP_PAE_3
PAEFIM_3:
	beq a0,a2,FIME_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAE_3
	
FIME_3:
	j A




PA_DIR_1:
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAD_2:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PADFIM_2
	addi a0,a0,1
	j LOOP_PAD_2
	
PADFIM_2:
	beq a0,a2,PA_DIR_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAD_2
	
PA_DIR_3:
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAD_3:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PADFIM_3
	addi a0,a0,1
	j LOOP_PAD_3
PADFIM_3:
	beq a0,a2,FIMD_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAD_3
	
FIMD_3:
	j B

PA_ESQ_1_CIMA:
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAEC_2:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PAECFIM_2
	addi a0,a0,1
	j LOOP_PAEC_2
	
PAECFIM_2:
	beq a0,a2,PA_ESQ_3_CIMA
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAEC_2

PA_ESQ_3_CIMA:
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PAEC_3:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PAECFIM_3
	addi a0,a0,1
	j LOOP_PAEC_3
PAECFIM_3:
	beq a0,a2,FIMEC_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PAEC_3
	
FIMEC_3:
	j C
	
PA_DIR_1_CIMA:
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PADC_2:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PADCFIM_2
	addi a0,a0,1
	j LOOP_PADC_2
	
PADCFIM_2:
	beq a0,a2,PA_DIR_3_CIMA
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PADC_2
	
PA_DIR_3_CIMA:
	li t0,0xFF000000	# endereco inicial bitmap 
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
LOOP_PADC_3:
	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,PADCFIM_3
	addi a0,a0,1
	j LOOP_PADC_3
PADCFIM_3:
	beq a0,a2,FIM_3
	addi a0,a0,320
	addi a0,a0,-29
	li t2,0
	j LOOP_PADC_3
	
FIM_3: j D
		

MARROM:
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	li t0,0xFF000000	# endereco inicial bitmap 
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
	

TRANSPARENTE:
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0xC7
LOOP_T: 	
	beq t1,t2,FIM		# Se for o último endereço então sai do loop
	sb t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,1		# soma 4 ao endereço
	j LOOP_T			# volta a verificar
	
START:
	li t0,0xFF000000	# endereco inicial bitmap 
	li a0,171		# x inicial da pa 
	li a1,132		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,315		# x final da pa
	li a3,235		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	la s0,start
	lw t0,0(s0)		# carrega colunas
	lw t1,4(s0)		# carrega linhas
	li t2,0
	addi s0,s0,8		# primeiro bit da pa
LOOP4:	lb t3,0(s0)
	sb t3,0(a0)
	addi t2,t2,1
	addi s0,s0,1
	beq t2,t0,SFIM
	addi a0,a0,1
	j LOOP4
	
SFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-144
	li t2,0
	j LOOP4
	
APAGA_START:
	li t0,0xFF000000	# endereco inicial bitmap 
	li a0,175		# x inicial da pa 
	li a1,216		# y inicial da pa
	li t1,320		# dim do bitmap
	mul a1,a1,t1		# 217 x 320
	add a0,a0,a1		# 35 (217 x 320)
	add a0,a0,t0		# a0 = endereco inicial + a0
	
	li a2,302		# x final da pa
	li a3,229		# x inicial da pa
	li t1,320
	mul a3,a3,t1
	add a2,a2,a3
	add a2,a2,t0		# a2 = endereco final da pa
	
	li t0,128		# carrega colunas
	li t1,14		# carrega linhas
	li t2,0
	li t3,0
LOOP_AS:
	sb t3,0(a0)
	addi t2,t2,1
	beq t2,t0,ASFIM
	addi a0,a0,1
	j LOOP_AS

ASFIM:	beq a0,a2,FIM
	addi a0,a0,320
	addi a0,a0,-127
	li t2,0
	j LOOP_AS
	
