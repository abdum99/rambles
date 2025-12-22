---
date: 2025-12-22
title: "The Shortcomings of \"everything is a file\" in a linux (`ioctl`)"
summary: ""
description: ""
draft: false
toc: false
autonumber: false
readTime: true
math: true
tags: ["linux", "file", "procfs", "sysctl", "ioctl"]
showTags: true
hideBackToTop: false
---
%% intro %%
Recently I was reading about different ways for the kernel to communicate or export information. Specifically, in the context of networking userspace mechanisms like `procfs` and `sysctl`. These are mechanisms for the kernel to export internal state to userspace processes.

<!-- which ones we're focusing on -->
Take `sysctl` for example. `sysctl` operates through the `/proc/sys` directory. It's a **virtual filesystem**. *Virtual* meaning it's *not actually a filesystem* that is mapped to storage and organizes data, *it's all pretend*. But it's a filesystem in the sense that *you can interact with it using classic POSIX `open()`, `read()`, `write()`* the way you would an actual filesystem.

## Why Filesystem Semantics
%% Benefit %%
This is a beautiful idea to simplify configuration of kernel variables and device drivers. The alternative would have been for the kernel to have a *separate system call for each functionality*. But since there's an ever-increasing amount of configuration the kernel has to handle, this would grow very quickly. Let's work with an example

%% Example %%
### IP Forwarding
Typically if your device gets an ip packet that is destined for somewhere else, it drops it. But sometimes we need to accept packets that are *not* destined for us. For example, if you're a router and your main job is to route traffic while rarely accepting traffic yourself. Or a firewall interface that has a different address on your system than the intended one, but it needs to check packets intended for you anyway to protect you from malicious traffic. Or you want to setup a [VPN container sidecar](./docker-vpn-kill-switch/container-vpn-kill-switch). There's many reasons. We call that **ip forwarding**. 
By default, for safety reasons or whatever, the kernel disables ip forwarding.
But let's say you want to enable it.
The kernel has two choices[^1] to give you, from a userspace process, the ability to enable it.

#### 1. System calls
The kernel can simply define new system call to give you control over ip forwarding. Something like:
```
int get_ip_forwarding(void);
int set_ip_forwarding(int enable);
```
This is simple, and understandable, but we had to make two system calls for a single simple variable. Think about all the kernel configuration variables and all the device drivers and imagine creating one, two, or three system calls for each. It grows fast. Which brings us to 2.

#### 2. "Everything Is a File"
Instead, the kernel can define a file. Yes, a file. `/proc/sys/net/ipv4/ip_forward`. You can read the file, and you can write to the file (given the right permissions) to check or configure ip forwarding. For example
```
# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```
which translates to
```
write(fd, "1\n", 2);
```
And that's it. You use the standard `open()`, `read()`, `write()` system calls.
That's the beauty of Linux's "everything is a file" philosophy

%% Benefit %%
The filesystem convention gives us a few things
- a path to identify a variable
- permission checks
- namespace awareness (top level directory)
- validation hooks

%% Limitation %%
## When file semantics stop making sense

The “everything is a file” idea works great **as long as the thing you’re controlling looks like a value**.

IP forwarding is a single boolean:
- `0` → off
- `1` → on

Reading and writing a number maps perfectly to `read()` and `write()`. But not everything in the kernel looks like that. Sometimes you don’t want to *read or write data* — you want to **issue a command**.

### Commands are not data
Imagine a device where you want to:
- reset it
- ask it for its capabilities
- tell it to start or stop doing something
- pass in a small structured request and get a structured response

You *could* try to squeeze this into file semantics:
- write special strings like `"reset\n"`
- invent magic numbers
- parse text in the kernel

But at this point the file semantics are more of an inconvenient mechanism than a helpful semantic. `read()` and `write()` stop being a good mental model.

## Enter `ioctl`

This is where `ioctl` comes in. `ioctl` literally stands for **input/output control**.  
Instead of sending raw bytes, you send a **named command**:
```c
ioctl(fd, RESET_DEVICE);
```

Or a command with a small argument:
```c
ioctl(fd, SET_MODE, &mode);
```

The important difference is intent:
- `write()` says: “here are some bytes”
- `ioctl()` says: “do this specific thing”

The kernel knows *what you’re asking*, not just *what you wrote*.

---

## Why not always use `ioctl` then?

Because `ioctl` is **not as simple**:
- commands are device-specific
- there’s no easy discovery (no `ls`)
- it’s harder to script

So Linux uses:
- **files** (`/proc`, `/sys`) for simple configuration
- **`ioctl`** when file semantics start to lie


---
[^1]: I lied there's a few other alternatives here (e.g. a unified control system call with an enum parameter, or even message-passing if you really want to make your life more difficult)
