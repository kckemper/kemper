
MAIN=avetest

camtest: ${MAIN}.c
	g++ `pkg-config opencv --cflags --libs` ${MAIN}.c -o ${MAIN}

clean:
	rm ./${MAIN}
