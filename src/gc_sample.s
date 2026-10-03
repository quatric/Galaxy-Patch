# hook: KPAD sampling callback, the `addi r0, r28, 1` after data format is stored
# (r28 = ring index, r29 = channel, r30 = the sample).
    .set    CHAN, 29
    .set    SMP, 30
#include gc_convert.s
    addi    0, 28, 1                    # displaced instruction
