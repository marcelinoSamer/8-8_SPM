# 8×8 Serial-Parallel Multiplier (SPM)

This project implements an 8×8 Serial-Parallel Multiplier (SPM). Initially a logisim design is submitted (11th May), and finally a full circuit design is provided. It demonstrates efficient binary multiplication by combining serial and parallel processing techniques.

## 🧠 Overview

The multiplier takes two 8-bit binary numbers as inputs:
- **Multiplicand**: Loaded in parallel.
- **Multiplier**: Loaded serially, one bit per clock cycle.

The system produces a 16-bit product, leveraging a combination of shift registers, adders, and control logic to perform the multiplication over multiple clock cycles.

## 📁 Project Structure

- `SPM.circ`: Logisim Evolution circuit file containing the main SPM design.
- `SPM.pdf`: Block diagram detailing the design specifications, architecture, and operation of the SPM.

## ⚙️ Features

- **Serial Input**: Accepts the multiplier bits serially, reducing input pin requirements.
- **Parallel Input**: Loads the multiplicand in parallel for faster setup.
- **Shift Registers**: Utilizes shift registers to manage bit-wise operations efficiently.
- **Control Logic**: Incorporates control mechanisms to synchronize operations across clock cycles.

## 🚀 Getting Started

1. **Install Logisim Evolution**:
   - Download from the [official website](https://github.com/reds-heig/logisim-evolution).
2. **Clone the Repository**:
   ```bash
   git clone https://github.com/marcelinoSamer/8-8_SPM.git
   ```
3. **Open the Project:**
   - Launch Logisim Evo
   - Open mainCircuit.circ

