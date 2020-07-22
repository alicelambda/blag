---
title: "UIUCTF 2020:Whats_A_Syscall 100"
date: DATE
draft: false
tags: ["ctf"]
description:  "Writing shellcode to call a special syscall"
---

This was the first challenge involving writing assembly. For the challenge. we have to call a special [syscall](https://github.com/sigpwny/pwnyOS-2020-docs/blob/master/Syscalls.pdf) to escape a sandbox. To call the syscall I used pwntools to compile the shellcode.

```python
from pwn import *
asm("move eax, 14")
asm("int 0x80")
asm("ret")
```

Setting `eax` to 14 is how we tell the kernel that we want to call the special syscall. Then interrupt 80 instruction tells the computer to execute the syscall.