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

# TODO: add support for other platforms
ifeq ($(OS),Windows_NT)
	PLATFORM := WINDOWS
	LFLAGS += -lopengl32 -lgdi32 -lwinmm
else
	UNAME := $(shell uname)
	ifeq ($(UNAME),Linux)
		PLATFORM := LINUX # set this for good measure
		LFLAGS += -lGL -lm
	else
		PLATFORM := NULL
	endif
endif

DEBUG := 1
ifeq ($(DEBUG),0)
	CFLAGS += -O2
	ifeq ($(PLATFORM),WINDOWS)
		LFLAGS += -mwindows
	endif
	# some things prefer checking for NDEBUG as opposed to DEBUG
	CFLAGS += -DNDEBUG=1
else
	CFLAGS += -ggdb -O0 -DDEBUG=1
endif

$(OUT): $(OBJ)
	@mkdir -p $(OUT_DIR)
	$(LD) $^ $(LFLAGS) -o $@

$(RAYLIB): 
	cd $(RAYLIB_DIR); make

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

run:
	./$(OUT)


cleanapp:
	rm -rf $(OUT_DIR) $(OBJ)

cleanray:
	cd $(RAYLIB_DIR); make clean

cleanall:
	$(MAKE) cleanapp cleanray

raylib: $(RAYLIB)
build:  $(OUT)
all:    $(RAYLIB) $(OUT)
