"""Where the hook trampolines and injected low-memory routines live.

Every patch is a set of operations: patches in the game code and routines/trampolines
in low memory. The DOL patcher allocates executable sections in unused slots for
the low-memory chunks.

In Super Mario Galaxy, low-memory routines live across:
  - 0x800009A0 - 0x80000BD0 (CC button unpacking and handlers)
  - 0x800014A0 - 0x80001600 (CC extension handling)
  - 0x80001820 - 0x80002400 (GameCube controller trampolines)
  - 0x80002780 - 0x800029C0 (CC stick pointer)
"""

CAVE_BASE = 0x800009A0
CAVE_LIMIT = 0x80003000

CC_BASE = 0x800009A0
CC_END = 0x800029C0

GC_BASE = 0x80001820
GC_END = 0x80002400

WINDOWS = {'cc': (CC_BASE, CC_END), 'gc': (GC_BASE, GC_END)}
