.data 
N_NOTAS: .word 75
NOTAS: 76,535,72,250,76,535,72,350,69,178,69,178,65,178,62,357,62,357,67,357,67,357,67,178,71,178,71,178,72,178,74,178,72,178,72,178,72,178,67,357,65,357,69,357,69,357,69,178,67,178,67,178,69,178,67,178,69,178,69,178,65,178,62,357,62,357,67,357,67,357,67,178,71,178,71,178,72,178,74,178,72,178,72,178,72,178,67,357,65,357,69,357,69,357,69,178,67,178,67,178,69,178,67,178,69,178,69,178,65,178,62,357,62,357,67,357,67,357,67,178,71,178,71,178,72,178,74,178,72,178,72,178,72,178,69,357,65,357,69,357,69,357,69,178,67,178,67,178,67,178

.text
	la s0,N_NOTAS		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,NOTAS		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,68		# define o instrumento
	li a3,127		# define o volume

LOOP:	beq t0,s1, FIM		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP			# volta ao loop
	
FIM:	li a0,40		# define a nota
	li a1,1500		# define a duração da nota em ms
	li a2,127		# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall			# toca a nota
	ret
