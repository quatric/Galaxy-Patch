# The GameCube pad -> Classic Controller conversion shared by the sampling-callback
# hook and the remote-less sample generator.  Assembled with
#   CHAN = register holding channel (0-3), SMP = register holding the 0x38-byte sample
# and ends at local label 9 (the caller places it).  Scratch: r0, r4-r12.
    cmplwi  CHAN, 3
    bgt     9f
    mulli   5, CHAN, 12
    lis     6, 0xCD00
    add     6, 6, 5
    lwz     8, 0x6404(6)                # INBUFH
    cmpwi   8, 0
    blt     9f                          # error / no pad
    andis.  0, 8, 0x0080
    beq     9f                          # not a valid pad response

    lwz     12, 0x6408(6)               # INBUFL
    srwi    5, 8, 16                    # PAD buttons in r5 (for mapbit)

    # Control stick X/Y -> Left stick (+-308 scale)
    rlwinm  10, 8, 24, 24, 31
    addi    10, 10, -128
    mulli   10, 10, 3
    clamp   10, 308
    sth     10, 0x2C(SMP)

    rlwinm  11, 8, 0, 24, 31
    addi    11, 11, -128
    mulli   11, 11, 3
    clamp   11, 308
    sth     11, 0x2E(SMP)

    # C-stick X/Y -> Right stick (+-308 scale)
    rlwinm  10, 12, 8, 24, 31
    addi    10, 10, -128
    mulli   10, 10, 3
    clamp   10, 308
    sth     10, 0x30(SMP)

    rlwinm  11, 12, 16, 24, 31
    addi    11, 11, -128
    mulli   11, 11, 3
    clamp   11, 308
    sth     11, 0x32(SMP)

    # Classic Controller buttons in r7
    li      7, 0
    mapbit  PAD_A,     CC_A             # Jump / Confirm
    mapbit  PAD_B,     CC_B             # Back / Cancel / Shoot / Dive
    mapbit  PAD_X,     CC_X             # Spin Attack
    mapbit  PAD_Y,     CC_X             # Spin Attack (both X and Y spin!)
    mapbit  PAD_START, CC_PLUS          # Pause menu
    mapbit  PAD_Z,     CC_ZL            # Crouch / Ground Pound / Long Jump
    mapbit  PAD_L,     CC_L             # Center Camera
    mapbit  PAD_R,     CC_ZR            # Shoot Star Bit / Lock On
    mapbit  PAD_UP,    CC_UP            # Camera / D-pad
    mapbit  PAD_DOWN,  CC_DOWN
    mapbit  PAD_LEFT,  CC_LEFT
    mapbit  PAD_RIGHT, CC_RIGHT
    sth     7, 0x2A(SMP)

    # Present as Classic Controller (dev=2, err=0, format=8)
    li      0, 2
    stb     0, 0x28(SMP)
    li      0, 0
    stb     0, 0x29(SMP)
    li      0, 8
    stb     0, 0x36(SMP)
    lbz     0, 0x37(SMP)
    ori     0, 0, 2
    stb     0, 0x37(SMP)                 # marker bit 1: GameCube pad active
9:
