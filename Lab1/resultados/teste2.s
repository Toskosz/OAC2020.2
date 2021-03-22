.data
.include "maze.s"

.text
# Carrega a imagem
draw_maze:
	la a0, maze	
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas	
    	
CENTRALIZA:
	li t3, 320		# x_tela
	li t4, 240		# y_tela
	li a3, 2		# 2
	div a4, t3, a3		# x_tela / 2
	div a5, a1, a3		# x_imagem / 2
	sub t3, a4, a5		# t3 = x_centro
	div a4, t4, a3		# y_tela / 2
	div a5, a2, a3		# y_imagem / 2
	sub t4, a4, a5		# t4 = y_centr
	li t5, 320    	
	mul t1, t5, t4		# t1 = t4 * 320
	add t1, t1, t3		# t1 = t1 + X
	
	
	
	add t0, t0, t1		# t0 = endereço do canto superior
    	addi a0,a0,8        	# primeiro pixels depois das informações de nlin ncol
    	mul t1,a1,a2            # numero total de pixels da imagem
    	li t2,0
    
DRAW_LOOP1: 
	beq t2,t1,DRAW_FIM        # Se for o último endereço então sai do loop
    	li t4,0
   
while2:    
	beq t4,a1,fim_loop    	#loop das colunas
    	lbu t3,0(a0)        	# carrega cor a ser pintada
    	sb t3,0(t0)        	# pinta no endereço t0
    	addi t0,t0,1       	
    	addi a0,a0,1
    	addi t2,t2,1       	# adiciona mais um pixel pintado
    	addi t4,t4,1		# pixel na coluna 
    	j while2
 
fim_loop: 
    	addi t0,t0,320        #proxima linha+numero de colunas
    	sub t0,t0,a1        #subtrai o numero de colunas
    	j DRAW_LOOP1        # volta a verificar

DRAW_FIM:
    	li a7, 10
    	ecall

