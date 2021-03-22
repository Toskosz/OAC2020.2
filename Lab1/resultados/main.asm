.data
.include "MAZE.s"
.include "MAZE.data"
CAMINHO: .space 153600

.text
.MAIN:	la a0, MAZE
	jal draw_maze
	la a0, MAZE
	la a1, CAMINHO
	jal solve_maze
	la a0, caminho
	jal animate
	li a7, 10
	ecall
	
draw_maze:
	