---
title: "CS373 Spring 2020: Alice Reuter Week11"
date: 2020-05-01 19:38:16 -0500
draft: false
readings: 3
tags: ["cs373"]
description: "A weekly update for my software engineering class where I discuss: Implementing crosscore communications for my multi-core operating systems class."
---

# 1. What did you do this past week?

This past week I worked on my take-home linear algebra test. I also worked on visualizations for my software engineering team website. For multi-core I worked on our team's implementation of cross core userspace message passing. We used two ring buffers on a split channel to pass messages between cores. Each message slot was the size of a cache line and we used arm memory fences to ensure cache coherency. It took me a while to understand what the dmb instruction does on arm and what the difference between the point of coherency and point of unification was. We also spent a while debugging synchronization issues. To spawn the kernel on the second core we needed to pass boot info that contained pointers to executables as well as pointers to that kernel's segment of memory. Our implementation segments memory between cores to simplify our memory management code. We were having issues where the first core overwrote the boot info for the second core before the second core had finished copying the boot info into its own address space. We solved this by implementing a synchronization protocol by polling at the end of the channel.

# 2. What's in your way?

I have a fair amount of work to get done for multicore and software engineering. I have to finish our teams' visualizations as well as record my part for our teams' video. 

# 3. What will you do next week?

Next week I will be finishing my UDP networking stack for multicore operating systems. 

# 4. What was your experience of refactoring?

I found refactoring to be pretty straightforward. It got me to reflect more on the usage of methods and how to associate methods.

# 5. What made you happy this week?

I had some more free time this week because I lot of my assignments were due Sunday and Monday of last week so I was able to game with friends. 

# 6. What's your pick of the week?

My pick of the week would be[redshift](https://wiki.archlinux.org/index.php/Redshift). Since everything has gone online during the pandemic, I've found that I've been looking at the computer screen much more than usual. Redshift prevents eyestrain by reducing the amount of blue light that comes out of your computer screen. 