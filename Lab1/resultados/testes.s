.data
.include "laranja.data"


.text

la a0, laranja
draw_maze:
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	addi a0,a0,8		# primeiro pixels depois das informações de nlin ncol

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
	
	li t2, 0		# pixeis feitos até o momento
	mul a3, a1, a2		# pixeis no total 
LOOP2:
	bge t2, a3, FIM
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
FIM:
	li, a7, 10
	ecall
	
PROXIMA_LINHA:
	addi t0,t0,320        		#proxima linha+numero de colunas
    	sub t0,t0,a1       		#subtrai o numero de colunas
    	j LOOP2        
