---
title: "CS373 Spring 2020: Alice Reuter Week6"
date: DATE
draft: false
readings: 3
tags: ["cs373"]
---

<img src="/img/cs373/linkedin.png" width="200" align="left" style="padding-right:2rem" />\

# 1. What did you do this past week?

This past week was midterm heavy for me, so I mostly worked on getting through midterms. We implemented interprocess communication and remote procedure calls in multicore this week too. I enjoyed implementing IPC because got to design our the protocol for packing and unpacking arguments. We also decided how to implement synchronization. 

# 2. What's in your way?
I have a few projects to work on over the break, but I'm mostly looking forward to relaxing.

# 3. What will you do next week?
Next week, I'm going to compete in a few (online) CTFs with my security team. The competition we had been training for [CCDC](https://www.nationalccdc.org) got rescheduled so I'm just working on keeping up the momentum. I've also been getting into making soups. I'm looking forward to making more hearty meals and waiting out the pandemic.

# 4. What was your experience of Test 1a?
I found this first question to be challenging. The strategy of skipping questions I was unsure about then coming back to them later worked well for me. I liked how I was able to get feedback on my implementation by just running them and seeing if they passed the test cases. I'm slightly worried about when or if we're going to have to take the second half since it got canceled today.

# 5. What made you happy this week?
My friend adopted a dog! I was relieved when school and exams were canceled due to coronavirus.

# 6. What's your pick-of-the-week?
[Let's Encrypt](letsencrypt.org) allows you too easily setup tls certificates to run a web server of https. You can make a cronjob that will automatically run certbot in order to keep the certificates up to date. 
```
43 6 * * * certbot renew
```
