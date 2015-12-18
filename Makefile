crash: crash.c
	gcc -Wall -pedantic $< -o $@ `pkg-config --cflags --libs gdk-pixbuf-2.0` -std=gnu99

clean:
	rm -f crash

test: crash
	while true; do echo understanding.gif; done | ./crash
