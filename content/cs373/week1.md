---
title: "CS373 Spring 2020: Alice Reuter Week 1"
date: 2020-02-02T17:54:32-06:00
draft: false
readings: 0
tags: ["cs373"]
---


<img src="/img/cs373/linkedin.png" width="200" align="left" style="padding-right:2rem" />

# 1. What did you do last week?
I finished milestone 0 for my multicore operating systems class. All we had to do was blink an led on the circuit board but it took a while to get used to low-level programming and reading manuals. I also started to look at the collatz project for this course. 

# 2. What's in your way?
I'm trying to better understand the requirements for this class. Getting started with collatz feels slightly overwhelming just because there's a lot of steps you need to do before you start developing.

# 3. What will you do next week?

I want to finish collatz fairly early on in the week so I have time for my other classes and deadlines. I also have linear algebra homework due on Thursday so I'm trying to get that done earlier as well.

# 4. What is your experience with assertions, unit tests, coverage, and continuous integration?
I used assertations during my principals of operating systems course last semester. We primarily used them to make sure our kernel was in a non-broken state.

I don't have a lot of experience with unit testing. I'm excited in using them as a guide for my development process. I have never used a tool that determines code coverage, but it seems useful.

The development team I worked with last summer practiced agile as well as continuous integration. The only times we ran into trouble was when: someone would break the master build or if we went too long without merging. When we went too long without merging, it took a lot of work to integrate everything.

# 5. What made you happy this week?
I left a student service org that I didn't feel supported/comfortable in. And it has felt good to have more free time and not be in that environment anymore.

# 6. What's your tip-of-the-week?
[Hugo](https://gohugo.io) is a static site generator written in Go. It's really easy to set up and extend. There are also a [ton](https://themes.gohugo.io) of themes that you can use and modify. I use Hugo to build my blog. I built a [docker container](https://hub.docker.com/r/alicelambda/hugo) that has Hugo installed so that I can automatically build my blog using Gitlab's CI/CD. Once the blog has been built it is then uploaded to Amazon S3 which is where I host my blog.
