.data
.include "mazeteste.s"
CAMINHO: .space 153600
X_VETOR: .word 161
Y_VETOR: .word 121

.text
.MAIN:	
	la a0, mazeteste
	jal draw_maze
	la a0, mazeteste
	la a1, CAMINHO
	jal solve_maze
	la a0, caminho
	jal animate
	li a7, 10
	ecall
	
draw_maze:
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	addi s1,s1,8		# primeiro pixels depois das informações de nlin ncol
CENTRALIZA:
	li t3, 320		# codigo para achar frame onde o canto superior direito esteja para imagem ficar centralizada
	li t4, 240		# 
	li a3, 2		# 
	div a4, t3, a3		# 			x = x_tela/2 - x_maze/2
	div a5, a1, a3		# 			y = y_tela/2 - y_maze/2
	sub t3, a4, a5		# 
	div a4, t4, a3		# 
	div a5, a2, a3		# 
	sub t4, a4, a5		# 
	li t5, 320    	
	mul t1, t5, t4		# 
	add t1, t1, t3		# ENDERECO = FF000000 + 320*Y + X)
	add t0, t0, t1		#
LOOP1: 	beq t1,t2,CENTRALIZA	# Terminou de desenha agora vai centralziar
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	addi s1,s1,4
	j LOOP1			# volta a verificar
	
