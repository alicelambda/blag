---
title: "UIUCTF 2020:Time_To_Start kernel 100"
date: DATE
draft: false
tags: ["ctf"]
description:  "Write up about the first ctf kernel challenge"
---


Shoutout to the [SIGPwny team](https://sigpwny.github.io/) and Ravi for their custom OS and kernel challenges! PwnyOS was the operating system used for the kernel challenges. We were given a [getting started guide](https://github.com/sigpwny/pwnyOS-2020-docs/blob/master/Getting_Started.pdf) and a [syscall guide](https://github.com/sigpwny/pwnyOS-2020-docs/blob/master/Syscalls.pdf). PwnyOS was also Animal Crossing themed and very cute.
![login png](/img/uiuctf/login.png)
Time_To_Start was the first kernel challenge. Since we connecting to pwnyOS vnc we were limited to sending printable ascii characters, the ones you can type. The getting started said that the username was sandb0x and the password began with p. The first thing I tried was to see what happened when I typed in a long password. When I submitted my string of aaaaaa's into the password field nothing interesting happened. I then tried to see what happened if used a username that wasn't the one given to me.
![username](/img/uiuctf/user.png)

 When I tried a different username I got a message that said wrong username. I then tried the first given character of the password p. 

![p](/img/uiuctf/p.png)

I then tried another letter and I noticed that time it took for the Incorrect Password prompt to come up was faster when the password incorrect. I then went through the letters of the alphabet after p. I found that pw was slower so I knew that the password started with pw. The challenge also stated that the password was four letters. So using my pwner intuitition and spidey senses I correctly guessed the password was pwny.
