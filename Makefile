PROJECT := orangeuefi
BUILD := build

override CC :=
override OBJCOPY :=

ifneq ($(strip $(CROSS_COMPILE)),)
ifneq ($(shell command -v $(CROSS_COMPILE)gcc 2>/dev/null),)
override CC := $(CROSS_COMPILE)gcc
override OBJCOPY := $(CROSS_COMPILE)objcopy
TARGET_FLAGS :=
endif
endif

ifeq ($(CC),)
override CC := clang
override OBJCOPY := llvm-objcopy
TARGET_FLAGS := --target=arm-none-eabi
endif

CFLAGS := $(TARGET_FLAGS) -mcpu=cortex-a7 -marm -ffreestanding -fno-builtin \
	-fno-stack-protector -Wall -Wextra -Os
LDFLAGS := $(TARGET_FLAGS) -mcpu=cortex-a7 -marm -nostdlib \
	-Wl,-T,linker.ld -Wl,-Map,$(BUILD)/$(PROJECT).map

ifneq ($(shell command -v arm-none-eabi-ld 2>/dev/null),)
LD := arm-none-eabi-ld
LD_FLAGS := -T linker.ld -Map=$(BUILD)/$(PROJECT).map
else
LD := $(CC)
LD_FLAGS := $(LDFLAGS)
endif

ELF := $(BUILD)/$(PROJECT).elf
BIN := $(BUILD)/$(PROJECT).bin
OBJECTS := $(BUILD)/start.o $(BUILD)/main.o

.PHONY: all clean

all: $(ELF) $(BIN)

$(BUILD):
	mkdir -p $@

$(BUILD)/start.o: src/start.S | $(BUILD)
	$(CC) $(TARGET_FLAGS) -mcpu=cortex-a7 -marm -c $< -o $@

$(BUILD)/main.o: src/main.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJECTS) linker.ld | $(BUILD)
	$(LD) $(LD_FLAGS) $(OBJECTS) -o $@

$(BIN): $(ELF) | $(BUILD)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(BUILD)
