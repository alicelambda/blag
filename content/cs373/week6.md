---
title: "CS373 Spring 2020: Alice Reuter Week 6"
date: 2020-03-15 20:26:35 -0500
draft: false
readings: 3
tags: ["cs373"]
description: "A weekly update for my software engineering class where I discuss: Remote procedure calls, how to set up TLS certificates and our midterm."
---


# 1. What did you do this past week?

This past week I had a lot of midterms, so I mostly worked on getting through them. We implemented interprocess communication and remote procedure calls in multicore this week too. I enjoyed implementing IPC because we got to design the protocol for packing and unpacking arguments. We also decided on how to implement synchronization. 

# 2. What's in your way?
I have a few projects to work on over the break, but I'm mostly looking forward to relaxing.

# 3. What will you do next week?
Next week, I'm going to compete in a few (online) CTFs with my security team. The competition we had been training for [CCDC](https://www.nationalccdc.org) got rescheduled so we've been working on keeping up the momentum. I've also been getting into making more soups. 

# 4. What was your experience of Test 1a?
I found this first question to be challenging. The strategy of skipping questions I was unsure of and then coming back to them later worked well for me. I liked how I was able to get feedback on my implementation by just running them and seeing if they passed the test cases. I'm slightly worried about when or if we're going to have to take the second half since it got canceled today.

# 5. What made you happy this week?
My friend adopted a dog! I was relieved when school and exams were canceled due to coronavirus.

# 6. What's your pick-of-the-week?
[Let's Encrypt](letsencrypt.org) allows you too easily setup TLS certificates to run a web server over https. You can make a cronjob that will automatically run certbot to keep the certificates up to date. 
```
crontab -e

43 6 * * * certbot renew
```
