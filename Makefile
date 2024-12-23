CC := gcc
LD := gcc

SRC_DIR := src
OUT_DIR := out

RAYLIB_DIR := external/raylib/src
RAYLIB     := $(RAYLIB_DIR)/libraylib.a

CFLAGS := -Wall
CFLAGS += -Wextra
CFLAGS += -std=c99
CFLAGS += -pedantic-errors
CFLAGS += -Wstrict-aliasing
CFLAGS += -Wformat=2
CFLAGS += -Wno-unused-parameter
CFLAGS += -Wfloat-equal
CFLAGS += -Wdouble-promotion

LFLAGS := $(RAYLIB)

SRC := $(wildcard src/*.c)
SRC += $(wildcard src/**/*.c)
SRC += $(wildcard src/**/**/*.c)
SRC += $(wildcard src/**/**/**/*.c)

OBJ := $(SRC:%.c=%.o)
OUT := $(OUT_DIR)/game

$(OUT): $(OBJ) $(RAYLIB)
	@mkdir -p $(OUT_DIR)
	$(LD) $(LIBRARY_FLAGS) $^ -o $@

$(RAYLIB):
	cd $(RAYLIB_DIR); make

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(OUT)
	./$(OUT)

clean:
	rm -rf $(OUT_DIR) $(OBJ)
	cd $(RAYLIB_DIR); make clean

build: $(OUT)
all:   $(OUT)

