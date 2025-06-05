# Include config.mk file
include config.mk

# Targets
application: clean $(PROG).elf $(PROG).S $(PROG).bin $(PROG).vmem $(PROG).dis reorder_files

# ELF target with OBJ dependecy
$(PROG).elf: $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "\n$(ORANGE)Compiling and assemblying...$(RESET)\n"
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $(BUILD_DIR)/$@

# Assembly target with OBJ dependecy
$(PROG).S: $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "\n$(ORANGE)Compiling to assembly code...$(RESET)\n"
	$(CC) $(CFLAGS) -c $(COMMON_INCS) $(MAIN_INCS) -fverbose-asm -g -O2 -S $(C_SRCS) 

# C to object files
%.o: %.c
	@mkdir -p $(BUILD_DIR)
	@echo "\n$(ORANGE)Compiling to object file...$(RESET)\n"
	$(CC) $(CFLAGS) -c $(COMMON_INCS) $(MAIN_INCS) -o $@ $<

# Assembly to object files
%.o: %.S
	@mkdir -p $(BUILD_DIR)
	@echo "\n$(ORANGE)Compiling to object file...$(RESET)\n"
	$(CC) $(CFLAGS) -c $(COMMON_INCS) $(MAIN_INCS) -o $@ $<

# BIN file from ELF
%.bin: %.elf
	@echo "\n$(ORANGE)BIN generation from ELF file...$(RESET)\n"
	$(OBJCOPY) -O binary $(BUILD_DIR)/$^ $(BUILD_DIR)/$@


# Disassemble ELF file
%.dis: %.elf
	@echo "\n$(ORANGE)Disassembly generation from ELF file...$(RESET)\n"
	$(DISASSEMBLY) -fhSD $(BUILD_DIR)/$^ > $(BUILD_DIR)/$@

# VMEM file from bin
%.vmem: %.bin
	@echo "\n$(ORANGE)VMEM generation from BIN file...$(RESET)\n"
	srec_cat $(BUILD_DIR)/$^ -binary -offset 0x0000 -byte-swap 4 -o $(BUILD_DIR)/$@ -vmem

# Spike ISA simulator
spike:
	@echo "\n$(ORANGE)Spike RISCV ISA simulator...$(RESET)\n"
	@mkdir -p $(SPIKE_DIR) 
	$(SPIKE) --isa=$(if $(filter 32,$(NBITS)),RV32GC,RV64GC) -l $(PK) $(BUILD_DIR)/$(PROG).elf 2> $(SPIKE_DIR)/$(PROG)_spike_trace.log

# Reorder generated files
reorder_files:
	@mv $(MAIN_DIR)/*.o $(BUILD_DIR)/
	@mv $(COMMON_DIR)/*.o $(BUILD_DIR)/
	@mv *.s $(BUILD_DIR)/

# Clean generated files
clean:
	@echo "\n$(ORANGE)Cleaning...$(RESET)\n"
	rm -rf $(OBJS) $(DEPS)
	rm -rf $(MAIN_DIR)/*~
	rm -rf $(COMMON_DIR)/*~
	rm -rf $(SPIKE_DIR)
	rm -rf $(BUILD_DIR)
	rm -rf ./*~
# Help target
help:
	@echo "$(ORANGE)\n"
	@echo "====================== Makefile Help ======================\n"
	@echo "To compile the program:       make PROG=program_name\n"
	@echo "To run with Spike simulator:  make spike PROG=program_name\n"
	@echo "To clean the build directory: make clean\n"
	@echo "===========================================================\n"
	@echo "$(RESET)"

