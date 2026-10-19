# 5-Stage Pipelined RISC-V (RV32I) Processor

A 5-stage pipelined RV32I processor designed in SystemVerilog and simulated
using Xilinx Vivado. The design follows the pipelined processor architecture
described in *Digital Design and Computer Architecture: RISC-V Edition* by
Sarah L. Harris and David Harris.

## Features
- 5-stage pipeline: Instruction Fetch (IF), Instruction Decode (ID),
  Execute (IE), Memory (IM) and Writeback (IWB)
- Pipeline registers between every stage
- Hazard unit handling data forwarding, load-use stalls and branch hazards
- Branch, JAL and JALR support
- Instruction memory, data memory and register file initialised from `.mem` files
- Self-contained testbench for behavioral simulation

## Pipeline Overview
| Stage | Modules |
|---|---|
| Fetch | `pc_ff.sv`, `instr_mem.sv`, `if_id_reg.sv` |
| Decode | `control_unit.sv`, `reg_file.sv`, `extend.sv`, `id_ie_reg.sv` |
| Execute | `alu.sv`, `branching_unit.sv`, `ie_im_reg.sv` |
| Memory | `data_mem.sv`, `im_iwb_reg.sv` |
| Writeback | Result mux back to `reg_file.sv` |
| Hazard control | `hazard_unit.sv` |
| Helpers | `mux.sv`, `mux3.sv`, `mux5.sv` |
| Top level | `riscv.sv` |

## Repository Structure
```
riscv_pipelined_processor/
├── src/        RTL source files (top module: riscv)
├── sim/        Testbench (riscv_tb.sv, module: tb)
├── mem/        Memory initialisation files
├── test/       Assembly test programs
│   ├── branch_stall/
│   ├── forwarding/
│   ├── jalr_jal_instr/
│   └── r_i_u_instr/
├── vivado/     create_project.tcl (rebuilds the Vivado project)
└── README.md
```

## Supported Instructions
- R-type arithmetic and logic
- I-type arithmetic and logic
- U-type (LUI, AUIPC)
- Load and store
- Branch instructions
- JAL and JALR

## Tests
| Test | Purpose |
|---|---|
| `test/branch_stall` | Checks stalling and flushing around branches |
| `test/forwarding` | Checks data forwarding between pipeline stages |
| `test/jalr_jal_instr` | Checks JAL and JALR behaviour |
| `test/r_i_u_instr` | Checks R-type, I-type and U-type instructions |

Each test folder contains an assembly (`.s`) program. The machine code is
loaded into the processor through `mem/instruction.mem`.

## Tools Used
- Xilinx Vivado (simulation)
- SystemVerilog (RTL and testbench)

## How to Run
1. Clone the repository:
```
   git clone <your-repo-url>
   cd riscv_pipelined_processor
```
2. Open Xilinx Vivado.
3. Go to **Tools → Run Tcl Script** and select `vivado/create_project.tcl`.
   This creates the project in `vivado/riscv_core/` with `riscv` as the
   design top and `tb` as the simulation top.
4. Click **Run Simulation → Run Behavioral Simulation**.

Alternatively, from a terminal:
```
cd vivado
vivado -mode batch -source create_project.tcl
```

To run a different test, load its machine code into `mem/instruction.mem`
and re-run the simulation.

## Reference
- Sarah L. Harris and David Harris, *Digital Design and Computer
  Architecture: RISC-V Edition*, Morgan Kaufmann.

## Author
Sabarish Mohan