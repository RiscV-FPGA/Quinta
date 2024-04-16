# Quinta

The project will be built for the Nexys A7-100T FPGA.

## General

- [x] fetch_stage
- [x] decode_stage
- [x] execute_stage
- [x] mem_stage
- [x] wb_stage

- [x] decompressor
- [x] instruction_memory
- [ ] control
- [x] data_memory
- [x] imm_gen
- [x] registers

- [ ] Branches
- [ ] Forwarding
- [ ] Hazard

## Phase1 instructions

- [ ] INSTR_LUI
- [ ] INSTR_BEQ
- [ ] INSTR_BNE
- [ ] INSTR_BLT
- [ ] INSTR_BGE
- [ ] INSTR_BLTU
- [ ] INSTR_BGEU
- [ ] INSTR_LW
- [ ] INSTR_SW
- [x] INSTR_ADDI
- [ ] INSTR_SLTI
- [ ] INSTR_SLTIU
- [x] INSTR_XORI
- [x] INSTR_ORI
- [x] INSTR_ANDI
- [ ] INSTR_SLLI
- [ ] INSTR_SRLI
- [ ] INSTR_SRAI
- [x] INSTR_ADD
- [x] INSTR_SUB
- [ ] INSTR_SLL
- [ ] INSTR_SLT
- [ ] INSTR_SLTU
- [x] INSTR_XOR
- [ ] INSTR_SRL
- [ ] INSTR_SRA
- [x] INSTR_OR
- [x] INSTR_AND

## Phase2 instructions

- [ ] INSTR_JAL
- [ ] INSTR_JALR
- [ ] INSTR_LBU
- [ ] INSTR_LHU
- [ ] INSTR_SB
- [ ] INSTR_SH
- [ ] INSTR_LB
- [ ] INSTR_LH
- [ ] INSTR_AUIPC
- [ ] INSTR_MUL
- [ ] INSTR_MULH
- [ ] INSTR_DIV
- [ ] INSTR_DIVU
- [ ] INSTR_REM
- [ ] INSTR_REMU

## Phase3 instructions

- [ ] INSTR_FLW
- [ ] INSTR_FSW
- [ ] INSTR_FADD_S
- [ ] INSTR_FSUB_S
- [ ] INSTR_FMUL_S
- [ ] INSTR_FDIV_S
- [ ] INSTR_FSQRT_S
- [ ] INSTR_FMV_X_W
- [ ] INSTR_FEQ_S
- [ ] INSTR_FLT_S
- [ ] INSTR_FLE_S
- [ ] INSTR_FMV_W_X

![Block Diagram](/doc/overview_riscV.png)
(todo: add beq comparition)

![Alt](https://repobeats.axiom.co/api/embed/8cecad938df30ff41abc7afbe6f5f0a3571eab39.svg "Repobeats analytics image")
