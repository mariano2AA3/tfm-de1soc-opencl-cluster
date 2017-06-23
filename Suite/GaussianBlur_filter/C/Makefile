compile: bin bin/image.o bin/filter.o bin/main.o
	gcc bin/image.o bin/filter.o bin/main.o -lm -oblur

bin: 
	mkdir bin/

bin/image.o: src/image.c
	gcc -o bin/image.o -c src/image.c

bin/filter.o: src/filter.c
	gcc -o bin/filter.o -c src/filter.c

bin/main.o: src/main.c
	gcc -o bin/main.o -c src/main.c

clean_compile: compile
	rm -rf bin
exec: compile
	./blur

#Parralel 
p_compile: bin bin/image.o bin/filter.o bin/p_main.o bin/metadata.o bin/common.o bin/master.o bin/slave.o
	mpicc bin/image.o bin/filter.o bin/p_main.o bin/metadata.o bin/common.o bin/master.o bin/slave.o -lm -op_blur

bin/p_main.o: src/parallel/p_main.c
	mpicc -o bin/p_main.o -c src/parallel/p_main.c

bin/metadata.o: src/parallel/metadata.c
	mpicc -o bin/metadata.o -c src/parallel/metadata.c

bin/common.o: src/parallel/common.c
	mpicc -o bin/common.o -c src/parallel/common.c

bin/master.o: src/parallel/master.c
	mpicc -o bin/master.o -c src/parallel/master.c

bin/slave.o: src/parallel/slave.c
	mpicc -o bin/slave.o -c src/parallel/slave.c

p_exec: p_compile
	mpiexec -n 5 ./p_blur
	
