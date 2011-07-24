all: physics.o
	g++ -o physics physics.o -I /usr/local/share/ode-0.11.1/include/ -l ode

physics.o: physics.cpp
	g++ -c -I /usr/local/share/ode-0.11.1/include/ -l ode physics.cpp

clean:
	rm -rf *.o
