# hook: KPAD read, `lbz r0, 0x10f(r31)` -- the read of sample count waiting in the ring
# (r31 = channel's KPAD struct, r27 = channel number).
# Scratch: r0, r3-r12; r3 holds the slot pointer.
    lbz     0, 0x10f(31)
    cmpwi   0, 0
    bne     9f                          # samples are waiting: a remote is producing them
    cmplwi  27, 3
    bgt     9f
    lbz     0, 0x10e(31)
    cmplwi  0, 0x78
    blt     slot
    li      0, 0
slot:
    mulli   3, 0, 0x38
    add     3, 3, 31
    addi    3, 3, 0x110                 # the next ring slot
    li      0, 0
    stw     0, 0x00(3)
    stw     0, 0x04(3)
    stw     0, 0x08(3)
    stw     0, 0x0c(3)
    stw     0, 0x10(3)
    stw     0, 0x14(3)
    stw     0, 0x18(3)
    stw     0, 0x1c(3)
    stw     0, 0x20(3)
    stw     0, 0x24(3)
    stw     0, 0x28(3)
    stw     0, 0x2c(3)
    stw     0, 0x30(3)
    stw     0, 0x34(3)
    .set    CHAN, 27
    .set    SMP, 3
#include gc_convert.s
    lbz     0, 0x37(3)
    andi.   0, 0, 2
    beq     9f                          # no pad answered: nothing to add
    lbz     5, 0x10e(31)
    cmplwi  5, 0x78
    blt     idx
    li      5, 0
idx:
    addi    5, 5, 1
    stb     5, 0x10e(31)
    lbz     5, 0x10f(31)
    cmplwi  5, 0x78
    bge     full
    addi    5, 5, 1
    stb     5, 0x10f(31)
full:
    # Notify game that controller has connected, once
    lwz     0, 0x1b98(31)
    cmpwi   0, 0
    beq     9f
    lbz     0, 0x1be2(31)
    cmpwi   0, 0
    bne     9f
    li      0, 1
    stb     0, 0x1be2(31)
    mr      3, 27
    li      4, 0
    lwz     12, 0x1b98(31)
    mtctr   12
    bctrl
    li      0, 0
    stb     0, 0x1be3(31)
    li      0, 1
    stb     0, 0x1bdf(31)
9:
    lbz     0, 0x10f(31)                # displaced instruction
