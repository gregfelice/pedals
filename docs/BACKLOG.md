# Backlog

Phase 0 -- awaiting hardware procurement.

## P0 — Blockers / Must-Do Next

- [ ] Order Daisy Seed (65MB, soldered headers) from Electrosmith
- [ ] Order Terrarium PCB from PedalPCB
- [ ] Order passives, enclosure, jacks, pots, footswitch from Tayda
- [ ] Order SSD1306 OLED + rotary encoder from Amazon

## P1 — v1 Build

- [ ] Solder Terrarium PCB + Daisy Seed
- [ ] Apply Rev7 noise fix (3.3K resistor + 2.2nF cap low-pass filter)
- [ ] Flash NeuralSeed firmware via USB-C DFU
- [ ] Validate audio path (clean signal, no hiss)
- [ ] Wire OLED + rotary encoder to I2C for model switching

## P2 — Model Training & Library

- [ ] Capture first amp (Fender Deluxe Reverb at edge of breakup) via PreSonus interface
- [ ] Train NAM model on GPU (~20 min on 4090)
- [ ] Quantize model to INT8, export for Daisy Seed
- [ ] Load trained model onto pedal, validate tone
- [ ] Capture additional amps/pedals (Vox AC30, Tube Screamer, etc.)
- [ ] Download community models from ToneHunt for comparison

## P3 — v2 Custom PCB

- [ ] Select reference design (bkshepherd's DaisySeedProjects or Terrarium-derived)
- [ ] Define v2 feature scope (OLED, encoder, MIDI, relay bypass, expression jack, stereo)
- [ ] Design schematic in KiCad (integrate Rev7 fix on-board)
- [ ] Layout PCB, route traces, verify clearances
- [ ] Design drill/panel template for enclosure
- [ ] Order prototype PCBs from JLCPCB
- [ ] 3D print test enclosure, validate fit
- [ ] Assemble, test, iterate
- [ ] Order final aluminum enclosure from Tayda (drill service + UV print)
