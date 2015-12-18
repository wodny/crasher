crash: crash.c
	gcc -Wall -pedantic crash.c -o crash `pkg-config --cflags --libs gdk-pixbuf-2.0` -std=gnu99

clean:
	rm -f crash

test:
	while true; do echo understanding.gif; done | ./crash
