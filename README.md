# crasher

## Introduction

In 2010 I noticed that viewing many GIFs in a row using gpicview renders 
my Linux unresponsive. The problem still exists. There is very little 
I can do in such a situation. Rarely after some minutes the OOM killer 
kicks in and saves the day. Nevertheless, usually I end up using 
Alt+SysRq+B.

What happens is gpicview exhausting whole available memory in such 
a pattern that userspace becomes unresponsive. My application 
(`crash.c`) allocates memory in a very similar way using GDK to 
replicate the problem.

I've observed the problem on two machines:

  - Asus EeePC 1000 with Atom N270 (2010-2014),
  - Lenovo S210 with Celeron 1037U (2014-…).

My current kernel is:
`3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u6 (2015-11-09) x86_64 
GNU/Linux`.

## Symptoms

The unresponsiveness goes with high CPU load and a lot of IO (read) 
operations on the root file system and its block device.

If I start the application from a text terminal (TTY) I can switch 
between them, but I gain nothing because shells in other terminals are 
unresponsive. Additionally I cannot perform any new logins (`fork` 
fails). If I stay at the same terminal I can kill the process almost 
immediately using a keystroke (e.g. ^C or ^\\). So apparently the kernel 
doesn't go into a deadlock.

When running the application under Xorg I cannot switch from X to
a text terminal. Probably because Xorg [uses][xorg-vt-proc]
[VT_PROCESS][vt-proc] to control terminal switching. Because the system 
is very busy Xorg doesn't get scheduled for running so it doesn't have 
time to acknowledge the switch request. Using SysRq+Alt+R [doesn't
help][vt-proc-auto].

## OOM killer not triggered

At first I thought that the OOM killer needs so much time to find and 
kill the process. But further experiments using just text terminals 
showed that the real problem is that the kernel doesn't notice it should 
use OOM killer to kill the naughty application. The experiment:

  0. switch to a text terminal, e.g. TTY2,
  0. run the application (`make test`) and stay at the TTY,
  0. wait until the system becomes unresponsive,
  0. wait a lot...
  0. either the kernel finally starts suspecting something and the OOM 
     killer terminates the application or you just press ^C or ^\ and 
     the system comes back almost immediately.

Killing the application with a signal sent via the TTY doesn't leave any 
suggestions in dmesg that anything bad happened. The only symptom is 
that for a moment the system behaves like after dropping caches.

## IO activity

`top` (or `htop`) and `iostat` are very useful in approximating the time 
left to the magic moment.

I suppose that in such a situation the OS starts to oscillate between 
freeing memory, cleaning caches and buffers, and loading some new data 
(see `iostat` logs).

I can observe the most impressive effects on my physical machine 
(`logs/ph-*`). On a VM (`logs/vm-*`) usually the OOM killer kills the 
process after a short time (5-120 seconds).

Logs from the VM have been gathered by piping `top` and `iostat` output 
to `netcat`. Logs from the physical machine have been gathered using 
primitive scripts and an Android phone connected over wifi.

Notice how the hang prevents scripts from reporting at stable 2-second
intervals.

## Factors

Possible factors differentiating cases of recovering in seconds from
recoveries after minutes (or never):

  - another memory-consuming process running (e.g. Firefox),
  - physical machine vs a VM (see dmesg logs),
  - chipset and associated kernel functions (see dmesg logs) but see the 
    remark on the `i915` module,
  - I'm ncursed.

Things that seem irrelevant (after testing):

  - running the application in Xorg or a TTY,
  - LUKS encryption of the root filesystem,
  - `vm.oom_kill_allocating_task` setting,
  - increasing `vm.admin_reserve_kbytes`,
  - using swap space,
  - disabling the `i915` module caused there are no i915-specific 
    functions in dmesg traces, but the system still blocks the same way,
  - running the application with `nice`.


## How to run

```
apt-get install libgdk-pixbuf2.0-dev
make && make test
```

With 4GB RAM + 256MB swap it needs about 100 iterations.

Any suggestions?



[xorg-vt-proc]: http://cgit.freedesktop.org/xorg/xserver/tree/hw/xfree86/os-support/linux/lnx_init.c
[vt-proc]: http://lxr.free-electrons.com/source/include/uapi/linux/vt.h
[vt-proc-auto]: http://thread.gmane.org/gmane.linux.kernel/951944
