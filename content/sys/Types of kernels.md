---
title: "What type of kernel are you?"
date: 2020-04-03T17:47:39-05:00
draft: true
readings: 3
---

There are three major models for kernels monolithic kernels, micro-kernels and exokernels. System's programming is about choosing between compromises. Each kernel model has it's own pros and cons I've created this quiz for entertainment purposes. 

Monolithic Kernel
- One api
- Multiplexing resources
- Unpredictable performance

Micro kernel
- Limited API
- Many tasks are run out in user space
- More complex to write

Exokernel
- No difference between user and kernel space
- Multiplexes hardware once
- System level things like managing memory are used for libraries
- Allows application specific policies for memory
