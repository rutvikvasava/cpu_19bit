# 19-bit CPU in VHDL

This repository contains the implementation of a custom 19-bit CPU in VHDL. Designed specifically for signal processing and cryptography, this CPU includes unique features like specialized encryption and decryption instructions, a 5-stage pipeline architecture, and a 19-bit instruction/data width. 

## Features

- **19-bit Instruction and Data Width**
- **16 General-Purpose Registers** (19-bit wide each)
- **Specialized Instructions** for FFT, encryption, and decryption
- **5-Stage Pipeline**: Fetch, Decode, Execute, Memory Access, Write-back
- **Harvard Architecture**: Separate instruction and data memory
- **Memory Size**: 524,288 addresses (2^19), with each storing 19-bit data

## Architecture Overview

### Register File
- 16 general-purpose registers (`gp_reg[0:15]`), each 19 bits wide.

### Memory Interface
- 524,288 addressable memory locations, with each address holding 19 bits of data.
- Separate instruction and data memory.

### ALU (Arithmetic Logic Unit)
- Supports arithmetic operations: ADD, SUB, MUL, DIV, INC, and DEC.
- Supports logical operations: AND, OR, XOR, NOT, NAND, and NOR.

### Specialized Operations
- **ENC**: Encryption using a simple XOR-based method.
- **DEC**: Decryption using the same XOR-based method.

## Pipeline Stages

1. **Fetch**: Retrieve the instruction from memory using the program counter (PC).
2. **Decode**: Decode the instruction to determine the opcode and operands.
3. **Execute**: Perform the operation specified by the opcode.
4. **Memory Access**: Access memory for load or store operations.
5. **Write-back**: Write results to the destination register.

## Instruction Set Architecture

The 19-bit instruction format is defined as follows:
- **Opcode**: `inst(18 downto 14)` (5 bits)
- **Register r1**: `inst(13 downto 10)` (4 bits)
- **Register r2**: `inst(9 downto 6)` (4 bits)
- **Register r3**: `inst(5 downto 2)` (4 bits)
- **Immediate Value**: `inst(18 downto 0)` (entire instruction)

### Instruction Opcodes

#### Arithmetic Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 00000  | Add `r2` and `r3`, store in `r1`        | `r1 = r2 + r3`         |
| 00001  | Subtract `r3` from `r2`, store in `r1`  | `r1 = r2 - r3`         |
| 00010  | Multiply `r2` and `r3`, store in `r1`   | `r1 = r2 * r3`         |
| 00011  | Divide `r2` by `r3`, store in `r1`      | `r1 = r2 / r3`         |
| 01010  | Increment `r1`                          | `r1 = r1 + 1`          |
| 01011  | Decrement `r1`                          | `r1 = r1 - 1`          |

#### Logical Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 00100  | Bitwise AND `r2` and `r3`, store in `r1` | `r1 = r2 AND r3`      |
| 00101  | Bitwise OR `r2` and `r3`, store in `r1`  | `r1 = r2 OR r3`       |
| 00110  | Bitwise XOR `r2` and `r3`, store in `r1` | `r1 = r2 XOR r3`      |
| 00111  | Bitwise NAND `r2` and `r3`, store in `r1` | `r1 = r2 NAND r3`    |
| 01000  | Bitwise NOR `r2` and `r3`, store in `r1`  | `r1 = r2 NOR r3`     |
| 01001  | Bitwise NOT on `r1`                      | `r1 = NOT r1`         |

#### Control Flow

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 01100  | Unconditional jump to address `immediate` | `PC = immediate`    |
| 01101  | Conditional jump if `r1 = r2`            | `if r1 = r2 then PC = immediate` |
| 01110  | Conditional jump if `r1 ≠ r2`            | `if r1 ≠ r2 then PC = immediate` |

#### Subroutine Call and Return

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 01111  | Call subroutine at `immediate`           | `stack[SP] = PC + 1; SP = SP - 1; PC = immediate` |
| 10000  | Return from subroutine                   | `SP = SP + 1; PC = stack[SP]` |

#### Memory Access Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 10001  | Load value from `immediate` into `r1`   | `r1 = mem[immediate]`  |
| 10010  | Store value in `r1` to address `immediate` | `mem[immediate] = r1` |

#### Specialized Operations

| Opcode | Description                             | Operation              |
|--------|-----------------------------------------|------------------------|
| 10011  | Encrypt data at `r1` using XOR with a key, store at `r2` | `ENC(r1) => r2` |
| 10100  | Decrypt data at `r1` using XOR with a key, store at `r2` | `DEC(r1) => r2` |

### Running the Simulation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rutvikvasava/cpu_19bit.git
   cd cpu_19bit
