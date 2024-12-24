CC := gcc
LD := gcc

SRC_DIR    := src
OUT_DIR    := out
RAYLIB_DIR := external/raylib/src

CFLAGS := -Wall
CFLAGS += -Wextra
CFLAGS += -std=c99
CFLAGS += -pedantic-errors
CFLAGS += -Wstrict-aliasing
CFLAGS += -Wformat=2
CFLAGS += -Wno-unused-parameter
CFLAGS += -Wfloat-equal
CFLAGS += -Wdouble-promotion
CFLAGS += -I$(RAYLIB_DIR)

SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(SRC_DIR)/**/*.c)
SRC += $(wildcard $(SRC_DIR)/**/**/*.c)
SRC += $(wildcard $(SRC_DIR)/**/**/**/*.c)

LFLAGS := -L$(RAYLIB_DIR) -lraylib

OBJ    := $(SRC:%.c=%.o)
OUT    := $(OUT_DIR)/game
RAYLIB := $(RAYBLIB_DIR)/libraylib.a

# assume windows by default
PLATFORM := WINDOWS

# TODO: add support for other platforms
ifeq ($(OS),Windows_NT)
	PLATFORM := WINDOWS
	LFLAGS += -lopengl32 -lgdi32 -lwinmm
endif

DEBUG := 1
ifeq ($(DEBUG),0)
	CFLAGS += -O2
        ifeq ($(PLATFORM),WINDOWS)
		LFLAGS += -mwindows
        endif
else
	CFLAGS += -ggdb -O0
endif

$(OUT): $(OBJ) | $(RAYLIB)
	@mkdir -p $(OUT_DIR)
	$(LD) $^ $(LFLAGS) -o $@

$(RAYLIB): 
	cd $(RAYLIB_DIR); make

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(OUT)
	./$(OUT)

clean:
	rm -rf $(OUT_DIR) $(OBJ)
	cd $(RAYLIB_DIR); make clean

raylib: $(RAYLIB)
build:  $(OUT)
all:    $(OUT)
