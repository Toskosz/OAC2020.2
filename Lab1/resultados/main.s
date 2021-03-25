.data
CAMINHO: .space 153600
.include "maze.data"
VERMELHO: .byte 15
AZUL: .byte 200
BRANCO: .byte 255
PRETO: .byte 0
ENTRADA: .word 21, 21
SAIDA: .word  21, 21

.text
.MAIN:	
	la a0, maze
	jal draw_maze
	la a0, maze
	la a1, CAMINHO
	jal solve_maze
	la a0, CAMINHO
	jal animate
	li a7, 10
	ecall
	
draw_maze:
	addi sp, sp, -4	# prepara a pilha para receber 2 words
	sw ra, (sp)	# empilha ra(End. Retorno)
	
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	addi a0,a0,8		# primeiro pixels depois das informações de nlin ncol
	jal CENTRALIZA
	lw ra, 0(sp)# restaurao endereçode retorno
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


solve_maze:
	addi sp, sp, -8		# prepara a pilha para receber 2 words
	sw ra, 4(sp)		# empilha ra(End. Retorno)
	sw a1, 0(sp)		# empilha endereco caminho
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	jal CENTRALIZA
	lw a1, 0(sp)		# restaura endereco caminho
	lw ra, 4(sp)		# restaurao endereço de retorno
	addi sp, sp, 8

	addi sp, sp, -4
	sw ra, 0(sp)			# empilha RA						# a's usados 
	jal ACHA_ENTRADA		# x e y da entrada							# a0 = mazeteste
	lw ra, 0(sp)			# restaura RA						# a1 = CAMINHNO
	addi sp, sp, 4											# t0 = pixel atual 
	
	
	addi sp, sp, -8	# prepara a pilha para receber 2 words
	sw ra, 4(sp)	# empilha ra(End. Retorno)
	sw a1, 0(sp)	# empilha endereco caminho
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 1
	lw a1,0(a0)        	# numero de coluna
    	lw a2,4(a0)        	# numero de linhas
	jal CENTRALIZA
	lw a1, 0(sp)# restaurao valordo argumenton
	lw ra, 4(sp)# restaurao endereçode retorno
	addi sp, sp, 8
	
	li t5, 320
	addi a2, a2, -1
	mul a3, a2, t5
	add t0, t0, a3		# bota t4 no ultimo pixel do canto esquerdo do labirinto
	add t4, t4, a2
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal ACHA_SAIDA		# acha x e y da saida
	lw ra, 0(sp)
	addi sp, sp, 4
	
	
	li a2, 0			# direcao, 0=cima	#
	li a3, 1			# 1=direita		#
	li a4, 2			# 2=baixo		#	direção da seta 
	li a5, 3			# 3=esquerda		#
	
	li s2, 0xFF000000
	la t6, ENTRADA
	li t5, 320
	lw t3, 0(t6)		# x da entrada
	lw t4, 4(t6)		# y da entrada
	mul t2, t5, t4		# 
	add t2, t2, t3		# ENDERECO = FF000000 + 320*Y + X)
	add s2, s2, t2		#
	
LOOP_SOLVE:
	li a6, 0		# quantidade de caminhos do pixel 
	beq s2, t0, SOLVE_2	# chegamos na outra saida no maze ?
	
	lb t1, 0(t0)
	la s1, BRANCO		
	lb t2, 0(s1)
	beq t1,t2, EH_BRANCO	# o pixel que eu estou agora é branco ?
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1,t2, EH_VERMELHO	# o pixel que eu estou agora é vermelho ?
	la s1, AZUL
	lb t2, 0(s1)
	beq t1, t2, EH_AZUL	# # o pixel que eu estou agora é azul ?
	
LOOP_SOLVE2:
	beq a2,zero, PAREDE_ESQUERDA_DCIMA		# parede da esquerda quando seta pra cima
	beq a2,a3, PAREDE_ESQUERDA_DDIREITA 		# parede da esquerda quando seta pra direita
	beq a2,a4, PAREDE_ESQUERDA_DBAIXO		# parede da esquerda quando seta pra baixo
	beq a2,a5, PAREDE_ESQUERDA_DESQUERDA		# parede da esquerda quando seta pra esquerda
	
EH_BRANCO:
	la s1, PRETO
	lb t2, 0(s1)
	lb t1, -320(t0)
	beq t1, t2, TEM_PAREDE_EM_CIMA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2 TEM_PAREDE_EM_CIMA
	la s1, AZUL
	lb t2, 0(s1)
	beq t1, t2 TEM_PAREDE_EM_CIMA
	addi a6, a6, 1				# se não tem parede em cima então +1 para as possiveis saidas do atual pixel
TEM_PAREDE_EM_CIMA:	
	lb t1, 1(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1, t2, TEM_PAREDE_NA_DIREITA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2, TEM_PAREDE_NA_DIREITA
	la s1, AZUL
	lb t2, 0(s1)
	beq t1, t2, TEM_PAREDE_NA_DIREITA
	addi a6, a6, 1				# se não tem parede na direita então +1 para as possiveis saidas do atual pixel
TEM_PAREDE_NA_DIREITA:
	lb t1, 320(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_EM_BAIXO
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_EM_BAIXO
	la s1, AZUL
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_EM_BAIXO
	addi a6,a6, 1				# se não tem parede em baixo então +1 para as possiveis saidas do atual pixel
TEM_PAREDE_EM_BAIXO:	
	lb t1, -1(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_NA_ESQUERDA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_NA_ESQUERDA
	la s1, AZUL
	lb t2, 0(s1)
	beq t1,t2, TEM_PAREDE_NA_ESQUERDA
	addi a6,a6, 1				# se não tem parede na esquerda então +1 para as possiveis saidas do atual pixel
TEM_PAREDE_NA_ESQUERDA:
	li t2, 2
	beq t2, a6, PINTA_AZUL			# se 2 possiveis saidas sem contar por onde eu vim então pinta de azul 
	li t2, 1
	beq t2, a6 PINTA_VERMELHO		# se só 1 possivel caminho pinto de vermelho 
	j LOOP_SOLVE2				# se não tiver caminho não muda a cor

PINTA_VERMELHO:
	la s1, VERMELHO
	lb t1, 0(s1)
	sb t1, 0(t0)
	j LOOP_SOLVE2

PINTA_AZUL:
	la s1, AZUL
	lb t1, 0(s1)
	sb t1, 0(t0)
	j LOOP_SOLVE2
	
EH_VERMELHO:			# se vermelho ja passamos aqui então pinta de branco
	la s1, BRANCO
	lb t1, 0(s1)
	sb t1, 0(t0)
	j LOOP_SOLVE2
	
EH_AZUL:			# se azul ja passamos aqui mas temos mais um possivel caminho 
	la s1, VERMELHO
	lb t1, 0(s1)
	sb t1, 0(t0)
	j LOOP_SOLVE2

# AS SEGUINTES FUNÇÕES PAREDE_XXXX, FRENTE_XXXX, ALTERA_BRANCO_XXXX E ANDA_XXXXX SÃO REFERENTE AO ALGORITMO DA MÃO ESQUEDA 	

PAREDE_ESQUERDA_DCIMA:
	lb t1, -1(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, FRENTE_DCIMA
	li a2, 3
	j ANDA_DESQUERDA

FRENTE_DCIMA:
	lb t1, -320(t0)
	la s1, BRANCO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DCIMA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DCIMA
	
	lb t1, 0(t0)
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2 ALTERNA_BRANCO_CIMA
	sb t2, 0(t0)
	li a2, 1
	j LOOP_SOLVE
ALTERNA_BRANCO_CIMA:
	la s1, BRANCO
	lb t2, 0(s1)
	sb t2, (t0)
	li a2, 1
	j LOOP_SOLVE
	
ANDA_DCIMA:
	addi t0, t0, -320
	j LOOP_SOLVE

PAREDE_ESQUERDA_DDIREITA:
	lb t1, -320(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, FRENTE_DDIREITA
	li a2, 0
	j ANDA_DCIMA

FRENTE_DDIREITA:
	lb t1, 1(t0)
	la s1, BRANCO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DDIREITA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DDIREITA
	lb t1, 0(t0)
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2 ALTERNA_BRANCO_DIREITA
	sb t2, 0(t0)
	li a2, 2
	j LOOP_SOLVE
ALTERNA_BRANCO_DIREITA:
	la s1, BRANCO
	lb t2, 0(s1)
	sb t2, (t0)
	li a2, 2
	j LOOP_SOLVE
	
ANDA_DDIREITA:
	addi t0, t0, 1
	j LOOP_SOLVE

PAREDE_ESQUERDA_DBAIXO:
	lb t1, 1(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, FRENTE_DBAIXO
	li a2, 1
	j ANDA_DDIREITA
	
FRENTE_DBAIXO:
	lb t1, 320(t0)
	la s1, BRANCO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DBAIXO
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DBAIXO
	lb t1, 0(t0)
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2 ALTERNA_BRANCO_BAIXO
	sb t2, 0(t0)
	li a2, 3
	j LOOP_SOLVE
ALTERNA_BRANCO_BAIXO:
	la s1, BRANCO
	lb t2, 0(s1)
	sb t2, (t0)
	li a2, 3
	j LOOP_SOLVE
	
ANDA_DBAIXO:
	addi t0, t0, 320
	j LOOP_SOLVE
	
PAREDE_ESQUERDA_DESQUERDA:
	lb t1, 320(t0)
	la s1, PRETO
	lb t2, 0(s1)
	beq t1,t2, FRENTE_DESQUERDA
	li a2, 2
	j ANDA_DBAIXO

FRENTE_DESQUERDA:
	lb t1, -1(t0)
	la s1, BRANCO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DESQUERDA
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2, ANDA_DESQUERDA
	lb t1, 0(t0)
	la s1, VERMELHO
	lb t2, 0(s1)
	beq t1, t2 ALTERNA_BRANCO_ESQUERDA
	sb t2, 0(t0)
	li a2, 0
	j LOOP_SOLVE
ALTERNA_BRANCO_ESQUERDA:
	la s1, BRANCO
	lb t2, 0(s1)
	sb t2, (t0)
	li a2, 0
	j LOOP_SOLVE
	
ANDA_DESQUERDA:
	addi t0, t0, -1
	j LOOP_SOLVE
	
	
ACHA_ENTRADA:				# ACHA X E Y DA ENTRADA E GUARDA NA MEMÓRIA
	la s1, BRANCO
	lb t1, 0(s1)
	lb t2, 0(t0)
	beq t1, t2, GUARDA_ENTRADA
	addi t0, t0, 1
	addi t3, t3, 1
	j ACHA_ENTRADA
	
GUARDA_ENTRADA:
	la t1, ENTRADA
	sw t3, 0(t1)
	sw t4, 4(t1)
	ret
	
ACHA_SAIDA:				# ACHA X E Y DA SAIDA E GUARDA NA MEMORIA 
	la s1, BRANCO
	lb t1, 0(s1)
	lb t2, 0(t0)
	beq t1, t2, GUARDA_SAIDA
	addi t0, t0, 1
	addi t3, t3, 1
	j ACHA_SAIDA
	
GUARDA_SAIDA:
	la t1, SAIDA
	sw t3, 0(t1)
	sw t4, 4(t1)
	ret
	
SOLVE_2:				# NESTE MOMENTO TEMOS UMA LINHA VERMELHA REPRESENTANDO O CAMINHO CERTO ESSA FUNÇÃO APAGA ESSA LINHA GUARDANDO O CAMINHO NA MEMORIA PARA QUE O ANIMATE NOVAMENTE O CAMINHO 
	la s1, VERMELHO
	lb t1, 0(s1)
	sb t1, 0(s2)

	li a2, 0				# contador
	la s1, VERMELHO
	lb t2, 0(s1)
	la s1, AZUL
	lb t3, (s1)
							# s2 = endereco da entrada
							# a1 endereco para caminho
	la t6, ENTRADA					# t2 = vermelho						
							# t3 = azul
	lw t4, 0(t6)					# t4 = x da entrada						
	lw t5, 4(t6)					# t5 = y da entrada 
	li t6, 320
	li s2, 0xFF000000
	mul a5, t6, t5
	add a5, a5, t4
	add s2, s2, a5				
	
	la t6, SAIDA
	lw a3, 0(t6)					# a3 = x da saida
	lw a4, 4(t6)					# a4 = y da saida 
	li t6, 320				
	li t0, 0xFF000000
	mul a5, t6, a4		# 
	add a5, a5, a3		# ENDERECO = FF000000 + 320*Y + X)
	add t0, t0, a5		#			# t0 é endereco da saida 

LOOP_VOLTA:			# LOOP DE VOLTA PARA A ENTRADA/SAIDA
	beq s2, t0, SOLVE_FIM

	lb t6, 1(s2)
	beq t2, t6, PROXIMO_PIXEL_DIREITA	# CONFERE SE PROXIMO PIXEL A DIREITA É VERMELHO OU AZUL
	beq t3, t6, PROXIMO_PIXEL_DIREITA
	lb t6, -1(s2)
	beq t2, t6, PROXIMO_PIXEL_ESQUERDA	# CONFERE SE PROXIMO PIXEL A ESQUERDA É VERMELHO OU AZUL
	beq t3, t6, PROXIMO_PIXEL_ESQUERDA
	lb t6, 320(s2)
	beq t2, t6, PROXIMO_PIXEL_BAIXO		# CONFERE SE PROXIMO PIXEL A BAIXO É VERMELHO OU AZUL
	beq t3, t6, PROXIMO_PIXEL_BAIXO
	lb t6, -320(s2)
	beq t2, t6, PROXIMO_PIXEL_CIMA		# CONFERE SE PROXIMO PIXEL A CIMA É VERMELHO OU AZUL
	beq t3, t6, PROXIMO_PIXEL_CIMA
	
# AS FUNÇÕES PROXIMO_PIXEL VOLTA A COR DO PIXEL PARA BRANCO E GUARDAM AS COORDENADAS EM MEMÓRIA
	
	
PROXIMO_PIXEL_DIREITA:
	sw t4, 4(a1)
	sw t5, 8(a1)
	addi t4 , t4, 1
	la s1, BRANCO
	lb t6, 0(s1)
	sb t6, 0(s2)
	addi s2, s2, 1
	addi a2, a2, 1
	addi a1, a1, 8
	j LOOP_VOLTA

PROXIMO_PIXEL_ESQUERDA:
	sw t4, 4(a1)
	sw t5, 8(a1)
	addi t4 , t4, -1
	la s1, BRANCO
	lb t6, 0(s1)
	sb t6, 0(s2)
	addi s2, s2, -1
	addi a2, a2, 1
	addi a1, a1, 8
	j LOOP_VOLTA
	
PROXIMO_PIXEL_BAIXO:
	sw t4, 4(a1)
	sw t5, 8(a1)
	addi t5 , t5, 1
	la s1, BRANCO
	lb t6, 0(s1)
	sb t6, 0(s2)
	addi s2, s2, 320
	addi a2, a2, 1
	addi a1, a1, 8
	j LOOP_VOLTA
	
PROXIMO_PIXEL_CIMA:
	sw t4, 4(a1)
	sw t5, 8(a1)
	addi t5 , t5, -1
	la s1, BRANCO
	lb t6, 0(s1)
	sb t6, 0(s2)
	addi s2, s2, -320
	addi a2, a2, 1
	addi a1, a1, 8
	j LOOP_VOLTA

SOLVE_FIM:		# APONTA A1 PARA O INICIO DA MEMÓRIA E GUARDA A QUANTIDADE DE PASSOS EM SEGUIDA VOLTA PARA A FUNCAO MAIN
	li t1, 8
	mul t2, a2, t1
	sub a1, a1, t2
	sw a2, 0(a1)
	ret 


animate:
	lw a1, 0(a0)		# numero de passos
	addi a0, a0, 4		# pula para o x da primeira coordenada
	li t4, 0		# passos realizados até agora
	la t5, VERMELHO
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
