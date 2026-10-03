# Assembly Sources and Feature Generators

This directory holds the PowerPC assembly sources and Python builders that compile the patches into the static JSON definitions in `tools/prebuilt/`.

## Architecture

Super Mario Galaxy links the Nintendo RVL_SDK KPAD library (release build Aug 29 2007).
The game natively expects input from a Wii Remote and Nunchuk, using accelerometer shakes for Mario's Spin Attack and the Wii Remote IR camera for the Star Pointer.

The patch provides two features:
1. **Classic Controller (`cc`)**: Hooks into the game engine's input manager, pointer routines, and panic handlers to natively process Classic Controller extension data (left stick moves Mario, right stick controls the Star Pointer, buttons map to jump, spin attack, crouch, star bit firing, and camera reset).
2. **GameCube Controller (`gc`)**: Polls the Serial Interface (SI) port matching the channel. If a GameCube controller is connected, it converts the pad state directly into a Classic Controller sample inside KPAD's sample ring (`dev=2, format=8`). When no Wii Remote is paired, the remote-less synthesizer generates the sample on demand and `WPADProbe` reports a Classic Controller is connected, enabling full standalone play without a Wii Remote.

## Files

- `macros.s`: Shared PowerPC assembly macros (`mapbit`, `absr`, `clamp`, `dead`).
- `gc_convert.s`: GameCube pad to Classic Controller sample converter.
- `gc_sample.s`: Hook at the KPAD sampling callback (`SAMPLE_ADDI`).
- `gc_synth.s`: Remote-less sample synthesizer hook at `RING_COUNT`.
- `gc_probe.s`: Hook at `WPADProbe` returning connected Classic Controller.
- `gen_common.py`: Shared constants, symbols, and hook assemblers.
- `gen_cc.py`: Generates the Classic Controller feature for each region.
- `gen_gc.py`: Generates the GameCube controller feature for each region.
- `cc_xml/`: Reference Classic Controller patch definitions across USA, Europe, Japan, and Korea.
