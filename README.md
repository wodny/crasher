# crasher

```
apt-get install libgdk-pixbuf2.0-dev
make && make test
```

In 2010 I noticed that viewing many GIFs in a row using gpicview renders my
Linux unresponsive. There is very little I can do in such a situation. Rarely
after some minutes the om nom nom killer kicks in and saves the day.
Nevertheless, usually I end up using Alt+SysRq+B. What happens is gpicview
exhausting whole available memory in such a pattern that userspace becomes
unresponsive. This tool allocates memory in a very similar way using GDK. In my
previous laptop I had a disk activity LED which lit up and stayed on when this
happened. I suppose that the OS starts to oscillate between freeing memory,
cleaning caches and buffers, and loading some new data. htop is very useful in
approximating the magic moment, but when it happens don't count on any windows
or terminals updating or allowing you to fork anything.

I can observe the most impressive effects on my physical machine with LUKS
encryption -- maybe it is relevant. On my VM usually the oomkiller kills the
process after a short time. It happens with or without swap. Running 
another memory-consuming application (e.g. Firefox) at the same time 
helps reproducing the problem.

With 4GB RAM + 256MB swap it needs about 100 iterations.

Any suggestions?
