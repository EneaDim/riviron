# 🚀 RISC-V Project Build System 🛠️

This README provides an overview of the build system for this RISC-V project, detailing the `config.mk` file, the associated `Makefile`, and the RISC-V toolchain — including **Spike** and the **Proxy Kernel**. Together, these components facilitate the **cross-compilation** of RISC-V applications, managing the toolchain, source files, and build processes.

---

## 📋 Overview

The project is structured to support the development of RISC-V applications using a cross-compilation toolchain.

- The `config.mk` file contains **configuration settings** for the toolchain and project structure.
- The `Makefile` defines the **build targets and rules** for compiling, assembling, and linking the application.

---

### 🔑 Key Components

1. **RISC-V GCC Toolchain** 🧰
 A set of compilers and tools for building RISC-V applications, including:
 - **GCC**: The GNU Compiler Collection for compiling C/C++ code.
 - **GDB**: The GNU Debugger for debugging applications.
 - **Binutils**: Tools for handling binary files, including `as` (assembler), `ld` (linker), and `objcopy`.

2. **Spike** 🖥️
 The RISC-V ISA simulator that allows you to run RISC-V binaries in a simulated environment — great for testing and debugging without hardware.

3. **Proxy Kernel (PK)** 🐚
 A lightweight kernel providing basic services for RISC-V applications running on Spike, handling system calls and providing a minimal runtime environment.

---

## ⚙️ Setting Up the Environment

### 🛠️ Prerequisites

Ensure you have the following installed on your system:

- A Unix-like OS (Linux or macOS) 🐧🍎
- Development tools: `make`, `git`, `gcc` 🔧

### 1️⃣ Install Dependencies

Run the `dependencies.sh` script to install the entire RISC-V toolchain, including Spike and the Proxy Kernel. This automates the installation process.

### 2️⃣ Set Up Environment Variables

Add the RISC-V toolchain to your `PATH` by adding this line to your `.bashrc` or `.bash_profile`:

```bash
export PATH=/opt/riscv/bin:$PATH
```

---

## 🚀 Usage

- Run `make help` to see the guide.
- Browse the `application/` folder and pick an application folder name.
- From root directory compile with:
```bash
make PROG="app\_name" 
```
- Run with Spike emulator:
```bash
make spike PROG="app\_name" 
```

### 📝 config.mk

The `config.mk` file is a configuration file that sets up the environment for cross-compiling RISC-V applications. It includes essential settings for the toolchain, compiler options, source files, and directory structure.

#### Key Sections

1. **Toolchain Settings**
. **CROSS_COMPILE**: Prefix for the RISC-V cross-compiler toolchain (default: `riscv64-unknown-elf`).
. **Compiler and Tools**: Defines the compiler (`CC`), assembler (`AS`), linker (`LD`), object copy tool (`OBJCOPY`), and disassembler (`DISASSEMBLY`).
2. **Architecture Settings**
. **ISA**: Instruction Set Architecture (default: `rv64gc`).
. **ABI**: Application Binary Interface (default: `lp64`).
3. **Compiler Optimizations**
. **COPT**: Compiler optimization flags (default: `-Os`).
4. **Linker Settings**
. **LINKER**: Path to the linker script (default: `linker/linker.ld`).
5. **Project Settings**
. **PROGRAM**: Name of the program to be built (default: `hello_world`).
. **Directory Structure**: Defines directories for build artifacts (`BUILD_DIR`), common sources (`COMMON_DIR`), and main application sources (`MAIN_DIR`).
6. **Source Files**
. **COMMON_SRCS**: Common C source files.
. **MAIN_SRCS**: Main application C source files.
. **EXTRA_SRCS**: Additional source files that can be specified.
7. **Include Directories**
. **COMMON_INCS**: Include path for common headers.
. **MAIN_INCS**: Include path for main application headers.

### 🛠️ Makefile

The `Makefile` utilizes the settings defined in `config.mk` to manage the build process. It defines various targets for compiling the application, generating different output formats, and cleaning up build artifacts.

#### Key Targets

- **application**: The main target that builds the application, generating ELF, assembly, binary, VMEM, and disassembly files.

- **ELF Target**: 
 **$(PROGRAM).elf**: Compiles the object files into an ELF executable.

- **Assembly Target**: 
 **$(PROGRAM).S**: Compiles the source files into assembly code.

- **Object File Compilation**: 
 **%.o: %.c**: Compiles C source files into object files.
 **%.o: %.S**: Compiles assembly source files into object files.

- **Binary and Disassembly Generation**: 
 **%.bin**: Generates a binary file from the ELF executable.
 **%.dis**: Generates a disassembly from the ELF executable.
 **%.vmem**: Generates a VMEM file from the binary file.

- **Spike ISA Simulator**: 
 **spike**: Runs the compiled ELF file in the Spike ISA simulator and logs the output.

- **File Management**: 
 **reorder_files**: Moves generated object files and assembly files to the build directory.
 **clean**: Cleans up generated files and directories.
