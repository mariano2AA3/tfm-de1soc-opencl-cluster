OS := $(shell uname)
OPTIONS:=-O3
SOURCE:=flow
PROGRAM:="flow"

ifeq ($(OS),Darwin)
	OPTIONS += -framework OpenCL
else
	OPTIONS += -l OpenCL
endif

$(SOURCE): $(SOURCE).c
	gcc -Wall -g $(SOURCE).c -o $(PROGRAM) $(OPTIONS)

clean:
	rm -rf $(PROGRAM)
