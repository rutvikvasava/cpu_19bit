# 19-bit CPU Architecture in VHDL

This project implements a custom 19-bit CPU in VHDL, designed for special-purpose operations such as signal processing and cryptography. The CPU is equipped with dedicated instructions for FFT, encryption, and decryption, and features a simple 5-stage pipeline architecture.

## Features

- **19-bit instruction size** and **19-bit data width**
- **16 general-purpose registers** (19 bits each)
- **Specialized instructions** for FFT, encryption, and decryption
- Support for **arithmetic, logical, control flow, and memory access instructions**
- **Simple pipeline** with five stages: Fetch, Decode, Execute, Memory Access, and Write-back
- **Harvard architecture** with separate instruction and data memory
- **Memory size**: 2^19 (524,288) addresses, each storing 19-bit data

## Architecture Overview

### Register File
- 16 general-purpose registers (`gp_reg[0:15]`), each 19 bits wide.

### Memory Interface
- Memory size of 524,288 addresses (2^19), each capable of holding a 19-bit word.
- Separate instruction and data memory (Harvard architecture).

### ALU (Arithmetic Logic Unit)
- Supports basic arithmetic operations: ADD, SUB, MUL, DIV, INC, and DEC.
- Supports logical operations: AND, OR, XOR, and NOT.

### Specialized Operations
- **FFT**: Fast Fourier Transform for signal processing.
- **ENC**: Encryption using a predefined algorithm.
- **DEC**: Decryption using a predefined algorithm.

## Pipeline Stages

1. **Fetch**: Retrieve the instruction from memory using the program counter (PC).
2. **Decode**: Decode the instruction to identify the opcode and operands.
3. **Execute**: Perform the operation specified by the opcode.
4. **Memory Access**: Access memory if the instruction is a load or store.
5. **Write-back**: Store the result back into the destination register.

## Instruction Set Architecture

With a 19-bit instruction size, the instruction fields are defined as follows:
- **Opcode**: `inst(18 downto 14)` (5 bits)
- **Register r1**: `inst(13 downto 10)` (4 bits)
- **Register r2**: `inst(9 downto 6)` (4 bits)
- **Register r3**: `inst(5 downto 2)` (4 bits)

### Instruction Opcodes

#### Arithmetic Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 00000  | Add values of `r2` and `r3`, store in `r1` | `r1 = r2 + r3`         |
| 00001  | Subtract `r3` from `r2`, store in `r1`     | `r1 = r2 - r3`         |
| 00010  | Multiply values of `r2` and `r3`, store in `r1` | `r1 = r2 * r3`  |
| 00011  | Divide `r2` by `r3`, store in `r1`        | `r1 = r2 / r3`         |
| 01000  | Increment value in `r1`                   | `r1 = r1 + 1`          |
| 01001  | Decrement value in `r1`                   | `r1 = r1 - 1`          |

#### Logical Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 00100  | Bitwise AND between `r2` and `r3`, store in `r1` | `r1 = r2 AND r3` |
| 00101  | Bitwise OR between `r2` and `r3`, store in `r1` | `r1 = r2 OR r3`  |
| 00110  | Bitwise XOR between `r2` and `r3`, store in `r1` | `r1 = r2 XOR r3` |
| 00111  | Bitwise NOT on `r1`                      | `r1 = ~r1`             |

#### Control Flow

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 01101  | Call subroutine at the specified address | `stack[SP] = PC + 1; SP = SP - 1; PC = addr` |
| 01111  | Return from subroutine                  | `SP = SP + 1; PC = stack[SP]` |

#### Memory Access Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 10000  | Load value from memory address into `r1` | `r1 = mem[address]`   |
| 10001  | Store value in `r1` to memory address    | `mem[address] = r1`   |

#### Specialized Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 10010  | Perform FFT on data at address `r1`, store result at `r2` | `FFT(r1) => r2` |
| 10011  | Encrypt data at address `r1`, store result at `r2` | `ENC(r1) => r2` |
| 10100  | Decrypt data at address `r1`, store result at `r2` | `DEC(r1) => r2` |

## Getting Started

### Prerequisites

- **VHDL Simulator**: This project requires a VHDL-compatible simulator like ModelSim, GHDL, or Vivado for testing and verification.
- **Hardware Synthesis Tools**: If you plan to synthesize this CPU for FPGA, you’ll need a tool like Xilinx Vivado or Intel Quartus.

### Running the Simulation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rutvikvasava/cpu_19bit.git
   cd cpu_19bit
