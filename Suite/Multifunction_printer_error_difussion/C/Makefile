OS := $(shell uname)
OPTIONS:=-O3
SOURCE:=printer
PROGRAM:="printer"

ifeq ($(OS),Darwin)
	OPTIONS += -framework OpenCL
else
	OPTIONS += -l OpenCL -l tiff
endif

$(SOURCE): $(SOURCE).c
	gcc -Wall -g *.c -o $(PROGRAM) $(OPTIONS)

clean:
	rm -rf $(PROGRAM)
