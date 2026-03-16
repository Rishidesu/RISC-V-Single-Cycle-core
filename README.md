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
- Main Decoder
- Immediate Generator/Sign Extender
- Data Memory
- Multiplexers for datapath control



#Main stages executed in a single clock cycle:

1. Instruction Fetch
2. Instruction Decode
3. Execute
4. Memory Access
5. Write Back

---

# Major Modules

## 1. Program Counter (PC)

### Purpose

The **Program Counter** stores the address of the current instruction being executed.

### Inputs

* `clk` – clock signal
* `rst` – resets PC to 0
* `pc_next` – next instruction address

### Output

* `pc` – current instruction address

### Operation

Every clock cycle:

PC ← PC_next

Normally:

PC_next = PC + 4

Since each RISC-V instruction is **32 bits (4 bytes)**.

Branch instructions can modify PC to jump to another address.

---

# 2. Instruction Memory

### Purpose

Stores the program instructions.

### Input

* `address` (from PC)

### Output(Instruction)

* `rd[31:0]`

### Operation

Instruction memory returns the **32-bit instruction located at the PC address**.

Instruction fields:
example-R type Instruction.

| Bits  | Field  |
| ----- | ------ |
| 31–25 | funct7 |
| 24–20 | rs2    |
| 19–15 | rs1    |
| 14–12 | funct3 |
| 11–7  | rd     |
| 6–0   | opcode |

---

# 3. Control Unit

### Purpose

Generates control signals required to operate the datapath.

### Input

* `opcode`

### Outputs

* `RegWrite`
* `MemWrite`
* `MemtoReg/resultsrc`
* `ALUSrc`
* `Branch`
* `ALUOp`

### Function

The control unit determines how the datapath behaves depending on the instruction type.

Example control signals:

| Signal   | Purpose                            |
| -------- | ---------------------------------- |
| RegWrite | Enable register write              |
| MemWrite | Enable data memory write           |
| ALUSrc   | Select register or immediate input |
| MemtoReg | Select ALU result or memory data   |
| Branch   | Enable branch decision             |

---

# 4. Register File

### Purpose

Stores **32 general purpose registers**.

Registers:

x0 – x31

### Inputs

* `a1`
* `a2`
* `a3`
* `write_data`
* `RegWrite`

### Outputs

* `read_data1`
* `read_data2`

### Operation

Two registers are read simultaneously:

read_data1 = Register[a1]
read_data2 = Register[a2]

If `RegWrite` is enabled:

Register[a3] ← write_data

---

# 5. Immediate Generator/sign extend

### Purpose

Extracts and sign-extends the **immediate value** from instructions.

Different instruction types use different formats.

Outputs a **32-bit immediate value** used by the ALU.

---

# 6. ALU Control (ALU Decoder)

### Purpose

Determines the **specific ALU operation**.

### Inputs

* `ALUOp`
* `funct3`
* `op[5]`
* `funct7[5]`

### Output

* `ALUControl[2:0]`

Example operations:

| ALUControl | Operation |
| ---------- | --------- |
| 000        | ADD       |
| 001        | SUB       |
| 010        | AND       |
| 011        | OR        |
| 100        | SLT       |

---

# 7. Arithmetic Logic Unit (ALU)

### Purpose

Performs arithmetic and logical operations.

### Inputs

* operand A
* operand B
* ALUControl

### Output

* result
* zero flag

Operations supported:

* ADD
* SUB
* AND
* OR
* SLT

The **zero flag** is used for branch decisions.

---

# 8. Data Memory

### Purpose

Stores data for load/store instructions.

### Inputs

* address
* write_data
* MemRead
* MemWrite

### Output

* read_data

Operations:

Load:

read_data = Memory[address]

Store:

Memory[address] ← write_data

---

# Architecture Details

## Module Hierarchy

The processor is organized in a hierarchical structure where the **top module (`riscv_core`) connects all datapath and control modules**.

```
riscv_core
│
├── p_c.v                  (Program Counter)
│
├── instruction_memory.v  (Instruction Fetch)
│
├── cu.v        (Main Control Logic)
│
├── register_file.v       (32 × 32-bit Registers)
│
├── sign_extend.v             (Immediate Generator)
│
├── alu_decoder.v         (ALU Control Unit)
│
├── alu.v                 (Arithmetic Logic Unit)
│
├── data_memory.v         (Load/Store Memory)
│
└── mux.v                 (Control data selection)
│
└── main_decoder.v       (Main decoder unit in control unit)         
```

### Top-Level Module Responsibility

The `riscv_core` module connects:

* Program Counter
* Instruction Memory
* Control Unit
* Register File
* Immediate Generator
* ALU Control
* ALU
* Data Memory
* Branch Logic
* Main decoder

It forms the **complete datapath of the processor**.

---

# RISC-V Instruction Formats

RISC-V instructions are **32 bits wide**.
Different instruction types use different field layouts.

---

# R-Type Instruction Format

Used for **register-to-register arithmetic operations**.

Example:

```
add x1, x2, x3
```

### Format

```
31    25 24   20 19   15 14   12 11    7 6     0
+--------+--------+--------+--------+--------+
| funct7 |  rs2   |  rs1   | funct3 |   rd   | opcode |
+--------+--------+--------+--------+--------+
```

### Fields

| Field  | Description          |
| ------ | -------------------- |
| funct7 | Operation extension  |
| rs2    | Source register 2    |
| rs1    | Source register 1    |
| funct3 | Operation type       |
| rd     | Destination register |
| opcode | Instruction type     |

### Operation Example

```
x1 = x2 + x3
```

---

# I-Type Instruction Format

Used for **immediate arithmetic and load instructions**.

Example:

```
addi x1, x2, 10
lw x1, 0(x2)
```

### Format

```
31        20 19   15 14   12 11    7 6     0
+------------+--------+--------+--------+--------+
|  immediate |  rs1   | funct3 |   rd   | opcode |
+------------+--------+--------+--------+--------+
```

### Fields

| Field     | Description          |
| --------- | -------------------- |
| immediate | 12-bit constant      |
| rs1       | Source register      |
| funct3    | Operation            |
| rd        | Destination register |
| opcode    | Instruction type     |

### Operation Example

```
x1 = x2 + immediate
```

---

# S-Type Instruction Format

Used for **store instructions**.

Example:

```
sw x1, 0(x2)
```

### Format

```
31    25 24   20 19   15 14   12 11    7 6     0
+--------+--------+--------+--------+--------+
|imm[11:5]| rs2 | rs1 | funct3 | imm[4:0] | opcode |
+--------+--------+--------+--------+--------+
```

### Fields

| Field     | Description           |
| --------- | --------------------- |
| imm[11:5] | Upper immediate       |
| rs2       | Register storing data |
| rs1       | Base address register |
| funct3    | Operation             |
| imm[4:0]  | Lower immediate       |

### Operation

```
Memory[rs1 + offset] = rs2
```

---


# RISC-V Single Cycle Datapath

The single cycle processor executes **all stages in one clock cycle**.

Processor stages:

1. Instruction Fetch
2. Instruction Decode
3. Execute
4. Memory Access
5. Write Back

---

# Full Processor Datapath (Conceptual)

```
             +----------------+
             |  Program Counter|
             +--------+-------+
                      |
                      v
              +---------------+
              | Instruction   |
              |   Memory      |
              +-------+-------+
                      |
                      v
             +-------------------+
             |  Instruction      |
             |  Decode / Control |
             +--------+----------+
                      |
          +-----------+-------------+
          |                         |
          v                         v
 +---------------+           +-------------+
 | Register File |           | sign        |
 |               |           | extend      |
 +-------+-------+           +------+------+ 
         |                          |
         v                          v
                +-----------------------+
                |         ALU           |
                +-----------+-----------+
                            |
                            v
                     +--------------+
                     | Data Memory  |
                     +------+-------+
                            |
                            v
                     +--------------+
                     | Write Back   |
                     +------+-------+
                            |
                            v
                      Register File
```

---

# Datapath for R-Type Instruction

Example:

```
add x1, x2, x3
```

Flow:

```
Instruction Memory → Register File → ALU → Register File
```

Steps:

1. Read registers `rs1` and `rs2`
2. ALU performs arithmetic
3. Result written to `rd`

---

# Datapath for I-Type Instruction

Example:

```
addi x1, x2, 10
```

Flow:

```
Instruction Memory → Register File → Immediate Generator → ALU → Register File
```

Steps:

1. Register `rs1` read
2. Immediate generated
3. ALU performs operation
4. Result written to `rd`

---

# Datapath for Load Instruction

Example:

```
lw x1, 0(x2)
```

Flow:

```
Instruction → Register File → ALU → Data Memory → Register File
```

Steps:

1. ALU calculates address
2. Data memory reads value
3. Value written back to register

---

# Datapath for Store Instruction

Example:

```
sw x1, 0(x2)
```

Flow:

```
Instruction → Register File → ALU → Data Memory
```

Steps:

1. ALU computes memory address
2. Data written from register to memory

---

# Branch Datapath

Example:

```
beq x1, x2, label
```

Flow:

```
Register File → ALU (compare) → Branch Decision → PC Update
```

If the ALU result is zero:

```
PC = PC + offset
```

Otherwise:

```
PC = PC + 4
```

---

# Summary

The RISC-V single cycle processor combines **control logic and datapath modules** to execute instructions within one clock cycle.

Major components include:

* Program Counter
* Instruction Memory
* Control Unit
* Register File
* Immediate Generator
* ALU Control
* ALU
* Data Memory

Each instruction type uses a **different datapath configuration** while sharing the same hardware resources.

# Simulation

Compile using Icarus Verilog:

```
iverilog -o out.vvp *.v
```

Run simulation:

```
vvp out.vvp
```

View waveform:

```
gtkwave Single_Cycle.vcd        
```

---

# Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave

---

# Author

Desu Rishi
Undergraduate Student – Electronics and Communication Engineering
Indian Institute of Information Technology, Design and Manufacturing (IIITDM), Jabalpur
## Areas of Interest

* Computer Architecture
* Digital System Design
* VLSI Design
* Processor Microarchitecture
* Hardware Description Languages (Verilog/SystemVerilog)

---

## Tools & Technologies

* Verilog HDL
* Icarus Verilog
* GTKWave
* Git & GitHub

