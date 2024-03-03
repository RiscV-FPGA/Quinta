- **Read chapter 4 - The Processor**
## 4.1 Introduction ✅
Simple explanation of a pipeline 

## 4.2 Logic Design Conventions ✅
About sequential and combinational logic, rising edge clk signals and some general clarification(buses, assert, desert and more)

## 4.3 Building a Datapath ✅
A RiscV processor without the control unit. This show the complete data path and how the PC (program counter) works. 
![[Pasted image 20240301162910.png]]

## 4.4 A Simple Implementation Scheme ✅
This chapter explains how the control signals are used for simple instructions in this non-pipelined processor. This shows some address manipulation to send correct control signals. 

## 4.5 An Overview of Pipelining ✅
**Hazards:**
- **structural hazard**
When a planned instruction cannot execute in the proper clock cycle because the hardware does not support the combination of instructions that are set to execute.

- **data hazard**
When a planned instruction cannot execute in the proper clock cycle because data that are needed to execute the instruction are not yet available.

- **control hazard**
When the proper instruction cannot execute in the proper pipeline clock cycle because the instruction that was fetched is not the one that is needed; that is, the flow of instruction addresses is not what the pipeline expected.

## 4.6 Pipelined Datapath and Control ✅
Introducing registers to the simple data path processor. Briefly describes how the control signals look with a pipelined architecture. 

## 4.7 Data Hazards: Forwarding versus Stalling ✅
Explains forwarding from wb to the alu which can reduce the number of times we have to stall. It also further explains how the control-signals work for the processor.  

## 4.8 Control Hazards ✅
Static and dynamic branch predictions. Explains what a tournament predictor is!

**Tournament branch predictor**
A branch predictor with multiple predictions for each branch and a
selection mechanism that chooses which predictor to enable for a
given branch.

Final figure with pipelining
![[Pasted image 20240303111720.png]]

## 4.9 Exceptions ✅
Two important registers to store in what state the exception occurred:

**SEPC:** A 64-bit register used to hold the address of the affected
instruction. (Such a register is needed even when exceptions are
vectored.)

**SCAUSE:** A register used to record the cause of the exception. In
the RISC-V architecture, this register is 64 bits, although most bits
are currently unused. Assume there is a field that encodes the
two possible exception sources mentioned above, with 2
representing an undefined instruction and 12 representing
hardware malfunction.

## 4.10 Parallelism via Instructions ✅
**Static multiple issue**
An approach to implementing a multiple-issue processor where many decisions are made by the compiler before execution.

**Dynamic multiple issue**
An approach to implementing a multiple-issue processor where

The chapter also explains out-of-order execution combined with in order commit using reservation stations. 
## 4.11 Real Stuff: The ARM Cortex-A53 and Intel Core i7 Pipelines ✅
Compares the ARM to the Intel processor. The ARM is simpler achieves a lower CPI 📉 but consumes way less power 📈. 

The Intel uses the x86 complex instruction set which it decodes down to micro-operations. 

## 4.12 Going Faster: Instruction-Level Parallelism and Matrix Multiply ✅
Simple example of a matrix multiplication with the loop unrolled in the gcc compiler. This greatly increases the performance. 

## 4.13 Advanced Topic: An Introduction to Digital Design Using a Hardware Design Language to Describe and Model a Pipeline and More Pipelining Illustrations ✅
A lot of verilog code and diagrams to show how different components of the five stage pipeline work. Note to self: look through this part later again to get a better understanding of the RiscV processor. 

## 4.14 Fallacies and Pitfalls ✅
Just two pages on some pipelining history and that it is very hard 😄. 

## 4.15 Concluding Remarks✅
Just a short conclusion. 

## 4.16 Historical Perspective and Further Reading✅
A lot of history about supercomputers and pipelining. 👴