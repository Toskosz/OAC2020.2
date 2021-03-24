.data
.include "mazeteste.s"
CAMINHO: .word 51, 159,110, 159,111, 160,111, 161,111, 162,111, 163,111, 164,111, 165,111, 165,112, 165,113, 166,113, 167,113, 168,113, 169,113, 169,114, 169,115, 169,116, 169,117, 168,117, 167,117, 167,116, 167,115, 166,115, 165,115, 165,116, 165,117, 165,118, 165,119, 166,119, 167,119, 167,120, 167,121, 168,121, 169,121, 169,122, 169,123, 169,124, 169,125, 168,125, 167,125, 166,125, 165,125, 165,126, 165,127, 165,128, 165,129, 164,129, 163,129, 162,129, 161,129, 161,130
COR: .byte 15

.text
.MAIN:	
	la a0, mazeteste
	jal draw_maze
	la a0, CAMINHO
	jal animate
	li a7, 10
	ecall

draw_maze:
	addi sp, sp, -4	# prepara a pilha para receber 2 words
	sw ra, 0(sp)	# empilha ra(End. Retorno)
	
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	addi a0,a0,8		# primeiro pixels depois das informações de nlin ncol
	
	jal CENTRALIZA
	lw ra, 0(sp)		# restaurao endereçode retorno
	addi sp, sp, 4
	
	li t2, 0		# pixeis feitos até o momento
	mul a3, a1, a2		# pixeis no total 
LOOP2:
	bge t2, a3, FIM_DRAW	# verifica se ja todos os pixeis ja foram feitos
	li a4, 0
LOOP1: 	
	beq a4,a1, PROXIMA_LINHA	# Terminou de desenha agora vai centralziar
	lb t3,0(a0)			# le byte do arquivo
	sb t3,0(t0)			# escreve o byte na memória VGA
	addi t0,t0,1			# proximo pixel da tela
	addi a0,a0,1			# proximo pixel do arquivo
	addi t2,t2,1			# +1 pixel pintado 
	addi a4,a4,1			# +1 coluna na linha
	j LOOP1				# volta a verificar
	
PROXIMA_LINHA:
	addi t0,t0,320        		#proxima linha+numero de colunas
    	sub t0,t0,a1       		#subtrai o numero de colunas
    	j LOOP2


# PRECISA DE: 
# a1 = numero de colunas
# a2 = numero de linhas 
# t0 = endereco inicial
# RETORNA:
# t3 = x centralizado
# t4 = y centralizado
# t0 = endereco centralizado

CENTRALIZA:
	li t3, 320		# codigo para achar frame onde o canto superior direito esteja para imagem ficar centralizada
	li t4, 240		# 
	li a3, 2		# 
	div a4, t3, a3		# 		   t3 =	x = x_tela/2 - x_maze/2
	div a5, a1, a3		# 		   t4 =	y = y_tela/2 - y_maze/2
	sub t3, a4, a5		# 
	div a4, t4, a3		# 
	div a5, a2, a3		# 
	sub t4, a4, a5		# 
	li t5, 320    	
	mul t1, t5, t4		# 
	add t1, t1, t3		# ENDERECO = FF000000 + 320*Y + X)
	add t0, t0, t1		#
	ret

FIM_DRAW:
	ret   

animate:
	lw a1, 0(a0)		# numero de passos
	addi a0, a0, 4		# pula para o x da primeira coordenada
	li t4, 0		# passos realizados até agora
	la t5, COR
LOOP3:
	li t0, 0xFF000000	# frame incial bitdisplay
	lw a2, 0(a0)		# x
	lw a3, 4(a0)		# y
	li t1, 320
	
	mul t2, a3, t1		# Y * 320
	add t2, t2, a2		# X + (Y*320)		
	add t0, t0, t2		# FF00000000 + (Y*320) + X
	
	lb t3, 0(t5)		# cor vermelha
	sb t3, 0(t0)		# carrega na tela a cor vermelha 
	addi a0, a0, 8		# vai pro proxima par de coordenadas x,y
	addi t4, t4, 1		# +1 pixel pintado
	beq t4, a1, ANIMATE_FIM
	j LOOP3

ANIMATE_FIM:
	ret
	
	
	
	
	
