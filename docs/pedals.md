# Neural Amp Modeler Guitar Pedal Build

<!-- mtoc-start -->

- Concept
  - Why neural networks beat traditional DSP
- Training
  - Community Models
  - Suggested First Captures
- Platform: Daisy Seed
- Latency Budget
- Sourcing
- v1 Build: Terrarium Platform
  - BOM (~$75-85 total)
  - Rev7 Noise Fix (Critical)
  - Controls (Terrarium standard layout)
- Firmware Options
- v2 Upgrade: Custom PCB via JLCPCB
- Build Phases

<!-- mtoc-end -->

## Concept

PyTorch can model analog audio circuits — tube amps, overdrive pedals, compressors — by training a neural network to replicate the exact nonlinear behavior of physical hardware. Feed a clean guitar signal into a real amp, record both the clean input and the amped output simultaneously, and train an RNN (LSTM or WaveNet-style dilated convolution) to learn the input-to-output transformation. The trained model captures everything: tube saturation, speaker cabinet resonance, compression behavior at different volumes, pick attack interaction with gain staging.

The project that proved this out is **NAM (Neural Amp Modeler)**. Open source, built on PyTorch. The community has trained models of hundreds of real amps and pedals. People run them in real-time on consumer hardware for live performance with single-digit millisecond latency.

### Why neural networks beat traditional DSP

Analog circuits are nonlinear in ways that are hard to model with equations. A tube amp's distortion character changes based on input level, frequency content, temperature, power supply load, and interactions between gain stages. SPICE simulation and Volterra series get close but never capture the _feel_. A neural network learns the mapping from input samples to output samples directly from the actual hardware — no physics model needed.

## Training

- Train on a 4090 GPU (or similar) in ~20 minutes from a 3-minute audio capture
- Capture input/output pairs from real hardware via audio interface
- The trained model is tiny: 50K-200K parameters
- Quantize to INT8 using PyTorch's quantization tools
- Export to ONNX or TFLite for embedded deployment
- WaveNet architecture sounds more accurate than LSTM — clearer, less muddy at equivalent processing power
- Warm cleans and edge-of-breakup tones (fingerpicking) are the sweet spot for small models; high-gain metal is where small models struggle

### Community Models

Browse and download pre-trained models of amps, pedals, and signal chains: https://tonehunt.net

### Suggested First Captures

- Fender Deluxe Reverb at edge of breakup
- Vox AC30 top boost clean
- Any favorite overdrive pedal (Tube Screamer, Klon, etc.)
- LA-2A compressor, 1176 compressor, Pultec EQ, tape machines — all capturable with the same pipeline

## Platform: Daisy Seed

The **Daisy Seed** ($21) is purpose-built for this:

- ARM Cortex-M7 at 480MHz
- Dedicated hardware audio codec (24-bit, 96kHz stereo)
- 64MB SDRAM, 8MB flash
- Enough to run real-time neural inference at 48kHz (one forward pass every ~20.8 microseconds)

## Latency Budget

Guitar players notice latency above ~10ms. Daisy Seed running a quantized GRU/WaveNet model comes in at 3-5ms. Comfortable margin.

## Sourcing

| Supplier            | What to buy there                                                        | URL                                           |
| ------------------- | ------------------------------------------------------------------------ | --------------------------------------------- |
| Electrosmith        | Daisy Seed (65MB, soldered headers)                                      | https://electro-smith.com/products/daisy-seed |
| PedalPCB            | Terrarium PCB                                                            | https://www.pedalpcb.com/product/pcb351/      |
| Tayda Electronics   | Enclosure, pots, jacks, footswitch, DC jack, LED, resistors, caps, knobs | https://www.taydaelectronics.com/             |
| Amazon / AliExpress | SSD1306 OLED, rotary encoder                                             | —                                             |
| JLCPCB (v2)         | Custom PCB fabrication + SMD assembly                                    | https://jlcpcb.com/                           |

## v1 Build: Terrarium Platform

### BOM (~$75-85 total)

| Component                               | Source            | ~Price |
| --------------------------------------- | ----------------- | ------ |
| Daisy Seed (65MB, soldered headers)     | Electrosmith      | $21    |
| Terrarium PCB                           | PedalPCB          | $9     |
| 1590B enclosure (or 3D print prototype) | Tayda             | $5-8   |
| 6x B10K pots (9mm)                      | Tayda             | $3     |
| 6x knobs                                | Tayda             | $3     |
| 2x 1/4" mono jacks (Lumberg)            | Tayda             | $3     |
| 1x 3PDT footswitch                      | Tayda             | $3     |
| 1x DC barrel jack (2.1mm)               | Tayda             | $1     |
| LED + bezel + CLR                       | Tayda             | $1     |
| 1x SSD1306 OLED (128x64, I2C)           | Amazon/AliExpress | $3-5   |
| 1x rotary encoder w/ push button        | Amazon/AliExpress | $2     |
| Misc resistors, caps, headers, wire     | Tayda             | $5-10  |
| 9V DC power supply (center negative)    | —                 | $8-12  |

### Rev7 Noise Fix (Critical)

Every Daisy Seed currently shipping (Rev7) produces audible hiss with the Terrarium's output buffer. **Proven fix:** 3.3K resistor in series followed by a 2.2nF cap to ground at the audio output, creating a 22kHz low-pass filter. $0.25 in parts — must do this or the pedal is unusable.

### Controls (Terrarium standard layout)

- 6 knobs (B10K pots mapped to Daisy ADC)
- 1 footswitch (bypass)
- OLED + rotary encoder for model selection/menu (wired to I2C pins, off-board on v1)

## Firmware Options

All C++ against Electrosmith's **libDaisy** library. Neural inference via **RTNeural** (lightweight C++ inference engine optimized for real-time audio on ARM). Not Arduino — bare-metal C++ compiled with ARM GCC toolchain.

| Project                            | Features                                                                                         | URL                                              |
| ---------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------ |
| **NeuralSeed**                     | NAM model loading, multi-model switching                                                         | https://github.com/GuitarML/NeuralSeed           |
| **Seed**                           | Multi-effect (reverb, delay, tremolo, looper) + neural amp modeling                              | https://github.com/GuitarML/Seed                 |
| **Mercury**                        | NAM on the Funbox pedal platform                                                                 | https://github.com/GuitarML/Mercury              |
| **bkshepherd's DaisySeedProjects** | OLED display, rotary encoder menu, 6 knobs, MIDI in/out, relay true bypass, open KiCad PCB files | https://github.com/bkshepherd/DaisySeedProjects  |
| **NAM (trainer)**                  | PyTorch model training pipeline                                                                  | https://github.com/sdatkinson/neural-amp-modeler |

## v2 Upgrade: Custom PCB via JLCPCB

JLCPCB is a Chinese PCB fab house. Upload KiCad Gerber files, get 5 professionally manufactured boards for ~$2-5 + ~$8-15 shipping, 3-5 day turnaround. They also do SMD assembly from their parts library.

### v2 Steps

1. **Pick reference design** — Fork bkshepherd's DaisySeedProjects KiCad files, or start from the Terrarium schematic and add what's missing
2. **Decide on features** — What goes natively on-board: OLED, encoder, MIDI in/out, relay true bypass, expression pedal jack, stereo out — pick your scope
3. **Choose enclosure size** — 125B is the standard for this complexity; determines PCB dimensions and panel layout
4. **Modify schematic in KiCad** — Add/remove components, update Daisy Seed footprint, integrate Rev7 noise fix directly on the board
5. **Layout the PCB** — Route traces, place components, check clearances; Daisy Seed mounts as a daughter board via pin headers
6. **Design drill/panel template** — Hole positions for pots, jacks, footswitch, OLED cutout, encoder; becomes both the Tayda drill file and the 3D print model
7. **Order prototype PCBs from JLCPCB** — Upload Gerbers, get 5 boards for ~$5; optionally add SMD assembly for surface-mount passives
8. **3D print a test enclosure** — Validate fit before committing to aluminum
9. **Assemble and test** — Solder through-hole components, flash firmware, verify audio path and controls
10. **Order final aluminum enclosure from Tayda** — With their drill service and UV print for graphics/labels

## Build Phases

1. **v1 Terrarium:** Order Daisy Seed + Terrarium PCB + passives. Solder it up. Apply Rev7 noise fix. Flash NeuralSeed firmware.
2. **Train first model:** Capture a real amp via audio interface. Train on GPU with NAM trainer. Load onto pedal.
3. **Add OLED + encoder:** Wire SSD1306 and rotary encoder to I2C for multi-model switching.
4. **Build model library:** Capture more amps, pedals, compressors. Community models also available.
5. **v2 custom PCB:** Design or fork a custom board, fab at JLCPCB, build the integrated version.
