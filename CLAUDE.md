# Pedals — Neural Amp Modeler Guitar Pedal

Hardware/firmware reference for building a guitar effects pedal using Neural Amp Modeler (NAM) on the Daisy Seed platform.

## Quick Reference

```bash
# OpenSCAD enclosure
openscad enclosure/v1-terrarium-1590b.scad

# Firmware (once hardware arrives)
# Flash NeuralSeed firmware to Daisy Seed via DFU
# See pedals.md for full build instructions
```

## Architecture

Neural inference pipeline: Analog Signal -> ADC (Daisy Seed) -> RTNeural C++ Inference -> DAC -> Analog Output.

### Source Layout

```
pedals/
├── pedals.md              # Master build guide (concept through v2)
├── shopping-list.md       # v1 BOM grouped by supplier
└── enclosure/
    └── v1-terrarium-1590b.scad  # Parametric 3D enclosure (Hammond 1590B)
```

### Hardware Stack
- **DSP:** Daisy Seed (ARM Cortex-M7, 480MHz)
- **Platform:** Terrarium PCB (v1), custom JLCPCB PCB (v2)
- **Inference:** RTNeural C++ engine
- **Training:** PyTorch NAM on GPU
- **Enclosure:** Hammond 1590B, 3D printed (OpenSCAD)

## Conventions

- Hardware design: OpenSCAD (parametric)
- PCB: KiCad (v2)
- Firmware: C++ with libDaisy
- Model training: PyTorch, captured via audio interface

## Key Documentation

| Document | Path |
|----------|------|
| Build Guide | `pedals.md` |
| Shopping List | `shopping-list.md` |
| Enclosure Design | `enclosure/v1-terrarium-1590b.scad` |

## Status

Phase 0 — Reference documentation complete. Awaiting hardware procurement (Daisy Seed + Terrarium PCB + passives). v2 custom PCB planned after v1 validation.
