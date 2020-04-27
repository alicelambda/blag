---
title: "CS373 Spring 2020: Alice Reuter Week11"
date: DATE
draft: false
readings: 3
tags: ["cs373"]
---

<img src="/img/cs373/linkedin.png" width="200" align="left" style="padding-right:2rem" />

# 1. What did you do this past week?

This past week I worked on my take home linear algebra test. I also worked on visualizations for my swe team website. I worked on our teams implementation of crosscore userspace message passing for mutlicore. We used two ring buffers on a split channel to pass messages between cores. Each message slot was the size of a cache line and we used arm memory fences to ensure cache coherency. It took me a while to understand what the dmb instruction does on arm and what the difference between the point oc coherency and point of unification was. We also spent a while debugging sycronization issues. In order to spawn the kernel on the second core we needed to pass bootinfo that contained pointers to executables as well as pointers to that kernels segment of memory. Our implementation segments memory between cores in order to simplify our memory management code. We we're having issues where the first core overwrote the bootinfo for the second core before the second core had finished copying the bootinfo into its own address space. We solved this by implementing a sycronization protocol by polling on the end of the channel.

# 2. What's in your way?

I have a fair amount of work to get done for multicore and swe. I have to finish our teams visualizations as well as record my part for our teams video. 

# 3. What will you do next week?

Next week I will be finishing my udp networking stack for mutlicore operating systems. 

# 4. What was your expercience of refactoring?

I found refactoring to be pretty straightforward. It got me to reflect more about the usage of methods and how to  associated methods.

# 5. What made you happy this week?

I had some more free time this week because I lot of my assigments were due sunday and monday of last week so I was able to game with friends. 

# 6. What's your pick of the week?

My pick of the week would be the [redshift](https://wiki.archlinux.org/index.php/Redshift). Since everything has gone online during the pandemic, I've found that I've been looking at the computer screen much more than usual. Redshift reduces eyestrain by reducing the amount of blue light that comes out of your computer screen. 