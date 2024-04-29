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
- [x] control
- [x] data_memory
- [x] imm_gen
- [x] registers

- [x] Branches
- [x] Forwarding
- [x] Hazard

## Phase1 instructions

- [x] INSTR_LUI
- [x] INSTR_BEQ
- [x] INSTR_BNE
- [x] INSTR_BLT
- [x] INSTR_BGE
- [x] INSTR_BLTU
- [x] INSTR_BGEU
- [x] INSTR_LW
- [x] INSTR_SW
- [x] INSTR_ADDI
- [x] INSTR_SLTI
- [x] INSTR_SLTIU
- [x] INSTR_XORI
- [x] INSTR_ORI
- [x] INSTR_ANDI
- [x] INSTR_SLLI
- [x] INSTR_SRLI
- [x] INSTR_SRAI
- [x] INSTR_ADD
- [x] INSTR_SUB
- [x] INSTR_SLL
- [x] INSTR_SLT
- [x] INSTR_SLTU
- [x] INSTR_XOR
- [x] INSTR_SRL
- [x] INSTR_SRA
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
