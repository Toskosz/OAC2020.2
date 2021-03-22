.data
v:
        .word   9                               # 0x9
        .word   2                               # 0x2
        .word   5                               # 0x5
        .word   1                               # 0x1
        .word   8                               # 0x8
        .word   2                               # 0x2
        .word   4                               # 0x4
        .word   3                               # 0x3
        .word   6                               # 0x6
        .word   7                               # 0x7
        .word   10                              # 0xa
        .word   2                               # 0x2
        .word   32                              # 0x20
        .word   54                              # 0x36
        .word   2                               # 0x2
        .word   12                              # 0xc
        .word   6                               # 0x6
        .word   3                               # 0x3
        .word   1                               # 0x1
        .word   78                              # 0x4e
        .word   54                              # 0x36
        .word   23                              # 0x17
        .word   1                               # 0x1
        .word   54                              # 0x36
        .word   2                               # 0x2
        .word   65                              # 0x41
        .word   3                               # 0x3
        .word   6                               # 0x6
        .word   55                              # 0x37
        .word   31                              # 0x1f

.text
main:                                   # @main
        addi    sp, sp, -16
        sw      ra, 12(sp)                      # 4-byte Folded Spill
        sw      s0, 8(sp)                       # 4-byte Folded Spill
        addi    s0, sp, 16
        lui     a0, %hi(v)
        addi    a0, a0, %lo(v)
        sw      a0, -16(s0)                     # 4-byte Folded Spill
        addi    a1, zero, 30
        sw      a1, -12(s0)                     # 4-byte Folded Spill
        call    show
        lw      a0, -16(s0)                     # 4-byte Folded Reload
        lw      a1, -12(s0)                     # 4-byte Folded Reload
        call    sort
        lw      a0, -16(s0)                     # 4-byte Folded Reload
        lw      a1, -12(s0)                     # 4-byte Folded Reload
        call    show
        mv      a0, zero
        lw      s0, 8(sp)                       # 4-byte Folded Reload
        lw      ra, 12(sp)                      # 4-byte Folded Reload
        addi    sp, sp, 16
        li a7, 10
        ecall

show:                                   # @show
        addi    sp, sp, -16
        sw      ra, 12(sp)                      # 4-byte Folded Spill
        sw      s0, 8(sp)                       # 4-byte Folded Spill
        addi    s0, sp, 16
        sw      a0, -12(s0)
        sw      a1, -16(s0)
        lw      a0, -12(s0)
        lw      a1, -16(s0)
        mv      t0, a0
        mv      t1, a1
        mv      t2, zero
loop1:
        beq     t2, t1, fim1
        addi    a7, zero, 1
        lw      a0, 0(t0)
        ecall   

        addi    a7, zero, 11
        addi    a0, zero, 9
        ecall   

        addi    t0, t0, 4
        addi    t2, t2, 1
        j       loop1
fim1:
        addi    a7, zero, 11
        addi    a0, zero, 10
        ecall   

        lw      s0, 8(sp)                       # 4-byte Folded Reload
        lw      ra, 12(sp)                      # 4-byte Folded Reload
        addi    sp, sp, 16
        ret
swap:                                   # @swap
        addi    sp, sp, -32
        sw      ra, 28(sp)                      # 4-byte Folded Spill
        sw      s0, 24(sp)                      # 4-byte Folded Spill
        addi    s0, sp, 32
        sw      a0, -12(s0)
        sw      a1, -16(s0)
        lw      a0, -12(s0)
        lw      a1, -16(s0)
        slli    a1, a1, 2
        add     a0, a0, a1
        lw      a0, 0(a0)
        sw      a0, -20(s0)
        lw      a0, -12(s0)
        lw      a1, -16(s0)
        slli    a1, a1, 2
        add     a1, a0, a1
        lw      a0, 4(a1)
        sw      a0, 0(a1)
        lw      a0, -20(s0)
        lw      a2, -12(s0)
        lw      a1, -16(s0)
        slli    a1, a1, 2
        add     a1, a1, a2
        sw      a0, 4(a1)
        lw      s0, 24(sp)                      # 4-byte Folded Reload
        lw      ra, 28(sp)                      # 4-byte Folded Reload
        addi    sp, sp, 32
        ret
sort:                                   # @sort
        addi    sp, sp, -32
        sw      ra, 28(sp)                      # 4-byte Folded Spill
        sw      s0, 24(sp)                      # 4-byte Folded Spill
        addi    s0, sp, 32
        sw      a0, -12(s0)
        sw      a1, -16(s0)
        mv      a0, zero
        sw      a0, -20(s0)
        j       .LBB2_1
.LBB2_1:                                # =>This Loop Header: Depth=1
        lw      a0, -20(s0)
        lw      a1, -16(s0)
        bge     a0, a1, .LBB2_10
        j       .LBB2_2
.LBB2_2:                                #   in Loop: Header=BB2_1 Depth=1
        lw      a0, -20(s0)
        addi    a0, a0, -1
        sw      a0, -24(s0)
        j       .LBB2_3
.LBB2_3:                                #   Parent Loop BB2_1 Depth=1
        lw      a0, -24(s0)
        mv      a1, zero
        mv      a2, a1
        sw      a2, -28(s0)                     # 4-byte Folded Spill
        blt     a0, a1, .LBB2_5
        j       .LBB2_4
.LBB2_4:                                #   in Loop: Header=BB2_3 Depth=2
        lw      a0, -12(s0)
        lw      a1, -24(s0)
        slli    a1, a1, 2
        add     a0, a0, a1
        lw      a1, 0(a0)
        lw      a0, 4(a0)
        slt     a0, a0, a1
        sw      a0, -28(s0)                     # 4-byte Folded Spill
        j       .LBB2_5
.LBB2_5:                                #   in Loop: Header=BB2_3 Depth=2
        lw      a0, -28(s0)                     # 4-byte Folded Reload
        andi    a0, a0, 1
        mv      a1, zero
        beq     a0, a1, .LBB2_8
        j       .LBB2_6
.LBB2_6:                                #   in Loop: Header=BB2_3 Depth=2
        lw      a0, -12(s0)
        lw      a1, -24(s0)
        call    swap
        j       .LBB2_7
.LBB2_7:                                #   in Loop: Header=BB2_3 Depth=2
        lw      a0, -24(s0)
        addi    a0, a0, -1
        sw      a0, -24(s0)
        j       .LBB2_3
.LBB2_8:                                #   in Loop: Header=BB2_1 Depth=1
        j       .LBB2_9
.LBB2_9:                                #   in Loop: Header=BB2_1 Depth=1
        lw      a0, -20(s0)
        addi    a0, a0, 1
        sw      a0, -20(s0)
        j       .LBB2_1
.LBB2_10:
        lw      s0, 24(sp)                      # 4-byte Folded Reload
        lw      ra, 28(sp)                      # 4-byte Folded Reload
        addi    sp, sp, 32
        ret


