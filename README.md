# RISC-V-Single-Cycle-core
Implementation of a 32-bit RISC-V Single Cycle Processor in Verilog including ALU, Control Unit, Register File and Memory modules with simulation support.

# RISC-V Single Cycle Processor (Verilog)

## Overview
This project implements a 32-bit RISC-V Single Cycle Processor using Verilog HDL. 
The processor executes each instruction in a single clock cycle and demonstrates the basic architecture of a RISC-V CPU including datapath and control logic.

The design was simulated using Icarus Verilog and GTKWave.

## Features
- 32-bit RISC-V architecture
- Single cycle execution
- Modular Verilog design
- ALU with multiple operations
- Register File with 32 registers
- Instruction Memory
- Data Memory
- Control Unit and ALU Decoder
- Branch and jump support
- Simulation with waveform analysis

## Architecture
The processor contains the following major modules:

- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File
- ALU
- ALU Decoder
- Immediate Generator
- Data Memory
- Multiplexers for datapath control

## Supported Instructions
Example instructions implemented:

- R-type: add, sub, and, or
- I-type: addi
- Load: lw
- Store: sw
- Branch: beq

## Project Structure
