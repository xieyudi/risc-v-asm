.PHONY: clean all run debug

SRC_DIR = src
OBJ_DIR = build

CFLAGS=-g
ASFLAGS=-g
LDFLAGS=-g -no-pie

TARGET = $(OBJ_DIR)/main.elf
OBJ = $(shell find $(SRC_DIR) -name '*.c' -or -name '*.S' | sed -r -e 's#.*\/(.*\.c)#'$(OBJ_DIR)'/\1\.o#g' -e 's#.*\/(.*\.S)#'$(OBJ_DIR)'/\1\.o#g')

$(TARGET): $(OBJ)
	riscv64-linux-gnu-gcc $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.S.o:	$(SRC_DIR)/%.S
	riscv64-linux-gnu-as $(ASFLAGS) -o $@ $<

$(OBJ_DIR)/%.c.o:	$(SRC_DIR)/%.c
	riscv64-linux-gnu-gcc $(CFLAGS) -c -o $@ $<

all:	clean $(TARGET)

clean:
	rm -f build/*

run:	$(OBJ_DIR)/$(TARGET)
	qemu-riscv64-static -L /usr/riscv64-linux-gnu/ $<

debug: $(TARGET)
	@echo "to debug interactively:"
	@echo "  qemu-riscv64-static -L /usr/riscv64-linux-gnu/ -g 1234 build/main.elf"
	@echo "launch gdb on a seperate terminal:"
	@echo "  riscv64-linux-gnu-gdb build/main.elf"
	@echo "inside gdb:"
	@echo "  target remote localhost:1234"