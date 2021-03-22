##################################################################
#  Programa de exemplo de uso de frames no Bitmap Display Tool   #
#  OAC Mar 2020			  			         #
#  Marcus Vinicius Lamar		  		         #
##################################################################
#
# Use o programa paint.net (baixar da internet) para gerar o arquivo .bmp de imagem 320x240 e 24 bits/pixel 
# para então usar o programa bmp2oac2.exe para gerar o arquivo .data correspondente para colocar no include
#


.data
.include "maze.s"


.text
# Carrega a imagem
MAIN:	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	la s0,maze		# endereço dos dados da tela na memoria
	lw s1,0(s0)		# numero de colunas
	lw s2,4(s0)		# numero de linhas
	addi s0,s0,8		# primeiro pixels depois das informações de nlin ncol
	mul t1,s1,s2            # numero total de pixels da imagem
	li t2,0
LOOP1: 	beq t1,t2,FIM		# Se for o último endereço então sai do loop
	lw t3,0(s0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na memória VGA
	addi t0,t0,4		# soma 4 ao endereço
	addi s0,s0,4
	addi t2,t2,1		# incrementa contador de bits
	j LOOP1			# volta a verificar


# devolve o controle ao sistema operacional
FIM:	li a7,10		# syscall de exit
	ecall
