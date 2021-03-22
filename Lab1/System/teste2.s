.data
.include "mazeteste.s"

.text
# Carrega a imagem
DRAW:    
    li t0,0xFF000000    # endereco inicial da Memoria VGA - Frame 0
    la a0, mazeteste
    lw a1,0(a0)        # numero de colunas
    lw a2,4(a0)        # numero de linhas
    addi a0,a0,8        # primeiro pixels depois das informações de nlin ncol
    mul t1,a1,a2            # numero total de pixels da imagem
    li t2,0
    
DRAW_LOOP1: bge t2,t1,DRAW_FIM        # Se for o último endereço então sai do loop
    li t4,0
    
while2:    beq t4,a1,fim_loop    #loop das colunas
    lbu t3,0(a0)        
    sb t3,0(t0)        
    addi t0,t0,1       
    addi a0,a0,1
    addi t2,t2,1       
    addi t4,t4,1
    j while2
 
fim_loop:
    addi t0,t0,320        #proxima linha+numero de colunas
    sub t0,t0,a1        #subtrai o numero de colunas
    j DRAW_LOOP1        # volta a verificar


# devolve o controle ao sistema operacional
DRAW_FIM:
    li a7, 10
    ecall