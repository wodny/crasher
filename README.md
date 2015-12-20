# crasher

```
apt-get install libgdk-pixbuf2.0-dev
make && make test
```

In 2010 I noticed that viewing many GIFs in a row using gpicview renders my 
Linux unresponsive. There is very little I can do in such a situation. Rarely 
after some minutes the om nom nom killer kicks in and saves the day.  
Nevertheless, usually I end up using Alt+SysRq+B.

What happens is gpicview exhausting whole available memory in such 
a pattern that userspace becomes unresponsive. This tool allocates 
memory in a very similar way using GDK.

`top` (or `htop`) and `iostat` are very useful in approximating the time left
to the magic moment, but when it happens don't count on any windows or
terminals updating or allowing you to fork anything.

I suppose that in such a situation the OS starts to oscillate between 
freeing memory, cleaning caches and buffers, and loading some new data 
(see `iostat` logs).

I can observe the most impressive effects on my physical machine 
(`logs/ph-*`). On my VM (`logs/vm-*`) usually the oomkiller kills the 
process after a short time (5-120 seconds).

Logs from the VM have been gathered by piping `top` and `iostat` output 
to `netcat`. Logs from the physical machine have been gathered using 
primitive scripts and an Android phone connected over wifi.

Notice how the hang prevents scripts from reporting at stable 2-second
intervals.

Possible factors differentiating cases of recovering in seconds from
recoveries after minutes (or never):

  - another memory-consuming process running (e.g. Firefox),
  - physical machine or a VM (see dmesg logs),
  - chipset and associated kernel functions (see dmesg logs).


With 4GB RAM + 256MB swap it needs about 100 iterations.

Any suggestions?
