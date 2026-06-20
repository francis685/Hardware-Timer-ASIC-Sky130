# AMBA APB-Compliant Hardware Timer: RTL-to-GDSII 

![RTL-to-GDSII](https://img.shields.io/badge/ASIC_Flow-OpenLane-blue)
![PDK](https://img.shields.io/badge/PDK-Sky130-green)
![Bus](https://img.shields.io/badge/Interface-AMBA_APB-orange)

## 📌 Project Overview
This repository documents the end-to-end RTL-to-GDSII physical design progression of a hardware timer targeting the SkyWater 130nm process node. 

The project is split into two evolutionary phases:
1. **Phase 1 (Core Logic):** Developing and physically routing a foundational 4-bit synchronous up-counter.
2. **Phase 2 (SoC Integration):** Upgrading the core logic by wrapping it in an industry-standard 32-bit Advanced Peripheral Bus (AMBA APB) interface, allowing it to function as a memory-mapped peripheral.

Both phases were synthesized, placed, and routed using the open-source **OpenLane** EDA flow.

---

## 🚀 Phase 1: Core Logic Implementation

* **Target Die Area:** $50 \times 50\ \mu\text{m}$
* **Logic:** 4-bit synchronous incrementer with asynchronous reset.
* **Verification:** Behavioral simulation via Xilinx Vivado.

### Phase 1 RTL Verification
*(DRAG_BASIC_WAVEFORM_HERE)*

> **Analysis:** Vivado simulation confirming structural logic integrity. The 4-bit count accurately increments on the positive edge of the clock.

### Phase 1 Physical Layout
*(DRAG_50x50_KLAYOUT_HERE)*

> **Analysis:** The physical macro layout utilizing the $50 \times 50\ \mu\text{m}$ die area constraint. Features horizontal standard cell rows and local interconnect routing for the core flip-flop logic.

---

## 🚀 Phase 2: AMBA APB Wrapper Integration

To standardize the IP for SoC architectures, an APB wrapper was developed to translate complex CPU read commands (`PSEL`, `PENABLE`, `PWRITE`) into standard clock/reset signals for the core logic, while padding the 4-bit output onto a 32-bit `PRDATA` bus.

* **Target Die Area:** $100 \times 100\ \mu\text{m}$ (Expanded to accommodate the 32-bit data bus routing).
* **Sign-off:** 0 DRC Violations, 0 LVS Errors.

### Phase 2 APB Read Transaction (Simulation)
*(DRAG_APB_WAVEFORM_HERE)*

> **Analysis:** A successful APB read transaction. When `PSEL` and `PENABLE` assert, the wrapper securely captures the underlying 4-bit counter value, zero-extends it to 32 bits, and outputs it onto the `PRDATA` bus with zero latency.

### Phase 2 Final GDSII Silicon Blueprint
*(DRAG_100x100_KLAYOUT_HERE)*

> **Analysis:** The final macroscopic routing view. The design clearly illustrates the dense routing network required to fan out the 32-bit AMBA data bus to the $100\ \mu\text{m}$ boundary.

---

## 👨‍💻 Author
**Francis Dsouza**
