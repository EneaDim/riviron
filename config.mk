# 32-64 BITS
NBITS            ?= 64
# Toolchain settings
CROSS_COMPILE    ?= riscv$(NBITS)-unknown-elf
# RISCV GCC version
GCC_VERSION      := $(shell $(CROSS_COMPILE)-gcc -dumpversion)
# Cross-Compiler
CC               := $(CROSS_COMPILE)-gcc
# Assembler
AS               := $(CROSS_COMPILE)-as
# Linker
LD               := $(CROSS_COMPILE)-ld
# Objcopy
OBJCOPY          := $(CROSS_COMPILE)-objcopy
# Disassembler
DISASSEMBLY      := $(CROSS_COMPILE)-objdump
# ISA
ISA              ?= rv$(NBITS)gc
# ABI
ifeq ($(NBITS),32)
ABI ?= ilp32d
else ifeq ($(NBITS),64)
ABI ?= lp64d
else
$(error Unsupported NBITS value: $(NBITS))
endif
# Compiler Optimizations
COPT             ?= -Os
# Linker
LINKER           ?= linker/linker.ld
# QEMU emulator
QEMU             ?= qemu-riscv$(NBITS)
# Spike ISA simulator
SPIKE            := spike
# Proxy Kernel
PK_ROOT          ?= opt
PK               ?= /$(PK_ROOT)/riscv-pk/riscv$(NBITS)-unknown-elf/bin/pk
# Project settings
PROG             ?= hello_world
# Build directory
BUILD_DIR        ?= build
# Common directory
COMMON_DIR       ?= common
# Main directory
MAIN_DIR         ?= applications/$(PROG)
# Common C sources
COMMON_SRCS      := $(wildcard $(COMMON_DIR)/*.c)
# Main C sources
MAIN_SRCS        := $(wildcard applications/$(PROG)/*.c)
# Common inlcudes
COMMON_INCS      := -I$(COMMON_DIR)
# Main includes
MAIN_INCS        := -I$(MAIN_DIR)
# Extra sources
EXTRA_SRCS       ?= 
# All sources
SRCS             := $(COMMON_SRCS) $(MAIN_SRCS) $(EXTRA_SRCS)
# C sources
C_SRCS           := $(filter %.c, $(SRCS))
# Assembler sources
ASM_SRCS         := $(filter %.S, $(SRCS))
# Code runtime 0
CRT              ?= $(COMMON_DIR)/crt0.S
# Compiler flags
CFLAGS           := -march=$(ISA) -mabi=$(ABI) -Wall -g $(COPT) -ffreestanding \
                   -static -mcmodel=medany -fvisibility=hidden \
                   #-nostdlib # -nostartfiles # => For Bare Metal System
# Linker flags
LDFLAGS          := -T $(LINKER) -static 
LDFLAGS_POST     := -Wl,--gc-sections -Wl,-Map=$(MAIN_DIR)/$(PROG).map
# Object files
OBJS             := ${C_SRCS:.c=.o} ${ASM_SRCS:.S=.o} ${CRT:.S=.o}
DEPS             := $(OBJS:%.o=%.d)
# Spike direcory
SPIKE_DIR        := isa-sim
# Colours
ORANGE           :=\033[38;5;214m
RESET            :=\033[0m


