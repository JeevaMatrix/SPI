## 📌 Overview

This project implements a fully functional SPI (Serial Peripheral Interface) protocol in Verilog, featuring both **master** and **slave** modules. The design supports configurable data width, synchronous serial communication, and waveform-accurate data exchange. It is suitable for interfacing with SPI-compatible peripherals such as ADCs, DACs, EEPROMs, and sensors.

---

## 🧩 Architecture

### 🔷 SPI Master
- Drives `sclk`, `cs_n`, and `MOSI`
- Receives `MISO` from slave
- FSM-based transmission control
- Shift register-based serialization
- Configurable `DATA_WIDTH` parameter

### 🔷 SPI Slave
- Samples `sclk` from master
- Receives `MOSI`, responds via `MISO`
- Shift register-based deserialization
- Bit counter for word alignment
- Preloads `TXS_DATA` on `cs_n` falling edge

### 🔗 Top Module (`spi_top`)
- Instantiates master and slave
- Connects SPI signals internally
- Exposes data ports for CPU interaction

---

## ⚙️ Features

| Feature              | Description |
|----------------------|-------------|
| **Parameterizable Width** | Supports arbitrary `DATA_WIDTH` (default: 8 bits) |
| **FSM Control**      | Clean state transitions: `IDLE → START → TRANSFER → STOP` |
| **Edge-Driven Clocking** | Master toggles `sclk` on `clk` edges; slave samples on `sclk` |
| **Full-Duplex Transfer** | Simultaneous transmit and receive |
| **Modular Design**   | Easily extendable for multi-slave or CPOL/CPHA support |

---

## 🧪 Simulation Testbench (`spi_top_tb`)

- Generates system clock (`clk`)
- Drives `tx_start` signal to initiate transfer
- Loads `master_tx_data` and `slave_tx_data`
- Monitors `master_rx_data` and `slave_rx_data`
- Verifies correct bitwise transfer and reception

---

## 🧠 Design Philosophy

This SPI implementation emphasizes:
- **Timing accuracy**: Aligns `sclk` with master `clk` for predictable edge behavior
- **Modularity**: Clean separation of master/slave logic for reuse
- **Debuggability**: FSM states and counters are observable in waveform
- **Scalability**: Easily extendable to support FIFO buffering, interrupts, or multiple slaves

---

## 🏭 Industry-Grade Enhancements (Future Scope)

To elevate this design to production-grade, consider adding:
- ✅ **Clock divider** for configurable `sclk` frequency  
- ✅ **CPOL/CPHA support** for compatibility with all SPI modes  
- ✅ **FIFO buffers** for burst transfers and decoupled timing  
- ✅ **Interrupt flags** (`transfer_done`, `data_ready`)  
- ✅ **Error detection** (overflow, underflow, misaligned `cs_n`)  
- ✅ **Multi-slave support** via addressable `cs_n` lines  
- ✅ **Formal verification hooks** for edge-case coverage  

---

## 📚 Use Case: Interfacing with ADC

This SPI master can be used to interface with SPI-compatible ADCs to read temperature sensor data:
- ADC converts analog voltage to digital bits
- SPI master initiates read and captures ADC output
- CPU reads `RX_DATA` for temperature processing

---

## 📁 File Structure

```
├── spi_master.v       // Master module
├── spi_slave.v        // Slave module
├── spi_top.v          // Top-level integration
├── spi_top_tb.v       // Testbench
└── README.md          // Documentation
```

---

## 🚀 Getting Started

1. Clone the repo or copy the RTL files  
2. Simulate using any Verilog simulator (e.g., ModelSim, Vivado, Icarus)  
3. Run `spi_top_tb.v` and observe waveform  
4. Modify `DATA_WIDTH`, `tx_start`, and input data to test various scenarios  

By Jeevanandh R | RTL | VLSI engineer
