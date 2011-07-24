
MAIN=main

camtest: ${MAIN}.cpp node.h net.h evo.h
	g++ `pkg-config opencv --cflags --libs` ${MAIN}.cpp -o ${MAIN}

clean:
	rm ./${MAIN} 
