# i have no idea why i made this makefile so bloated, but is
# so be it

CC := gcc
LD := gcc

SRC_DIR    := src
OUT_DIR    := out
RAYLIB_DIR := external/raylib/src

CFLAGS := -Wall -Wextra -std=c99 -pedantic-errors
CFLAGS += -Wall -Wstrict-aliasing -Wformat=2 -Wno-unused-parameter
CFLAGS += -Wfloat-equal -Wdouble-promotion
CFLAGS += -I$(RAYLIB_DIR)

SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(SRC_DIR)/**/*.c)
SRC += $(wildcard $(SRC_DIR)/**/**/*.c)
SRC += $(wildcard $(SRC_DIR)/**/**/**/*.c)

LDFLAGS := -L$(RAYLIB_DIR) -lraylib

OBJ    := $(SRC:%.c=%.o)
OUT    := $(OUT_DIR)/game
RAYLIB := $(RAYBLIB_DIR)/libraylib.a

# platform deteciton
ifeq ($(OS),Windows_NT)
	PLATFORM := WINDOWS
	LDFLAGS += -lopengl32 -lgdi32 -lwinmm
else
	UNAME := $(shell uname)
	ifeq ($(UNAME),Linux)
		PLATFORM := LINUX # set this for good measure
		LDFLAGS += -lGL -lm
	else
		PLATFORM := NULL
	endif
endif

# toggle debug and release mode (non-zero enables debug mode)
DEBUG := 1
ifeq ($(DEBUG),0)
	CFLAGS += -O2
	ifeq ($(PLATFORM),WINDOWS)
		LDFLAGS += -mwindows
	endif
	# some things prefer checking for NDEBUG as opposed to DEBUG
	CFLAGS += -DNDEBUG=1
else
	CFLAGS += -ggdb -O0 -DDEBUG=1
endif

$(OUT): $(OBJ)
	@mkdir -p $(OUT_DIR)
	$(LD) $^ $(LDFLAGS) -o $@

$(RAYLIB): 
	cd $(RAYLIB_DIR); $(MAKE)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# build options
build:  $(OUT)
raylib: $(RAYLIB)
all: raylib build

run:
	./$(OUT)

cleanapp:
	rm -rf $(OUT_DIR) $(OBJ)

cleanray:
	cd $(RAYLIB_DIR); $(MAKE) clean

cleanall: cleanapp cleanray
