---
title: "Pwnable"
date: DATE
draft: false
tags: ["ctf","pwn"]
description:  "A writeup of the challenges from Pwnable.kr, a systems exploitation war game."
---
[pwnable.kr](https://pwnable.kr) is a site with a series of capture the flag challenges with increasing difficulty. Below are my notes working through each challenge.

# Collision
The point of this challenge was to find a value whose hash would match the harcoded hash. I added debugging statements to the hash code so that I see the computed hash. 
``` c
#include <stdio.h>
#include <string.h>
unsigned long hashcode =0x21DD09EC;
//                        33333332
unsigned long check_password(const char* p){
    int* ip = (int*)p;
    int i;
    int res=0;
    for(i=0; i<5; i++){
        res += ip[i];
        printf("%x\n",ip[i]);
    }
    return res;
}

int main(int argc, char* argv[]){
    if(argc<2){
        printf("usage : %s [passcode]\n", argv[0]);
        return 0;
    }
    if(strlen(argv[1]) != 20){
        printf("passcode length should be 20 bytes\n");
        return 0;
    }

    printf("result: %x\n",check_password(argv[1]));
    if(hashcode == check_password( argv[1] )){
        system("/bin/cat flag");
        return 0;
    }
    else
        printf("wrong passcode.\n");
    return 0;
}
```
The string of letters is decoded as ints. Since an int is 4 bytes long the string is read in 4 byte chunks. This means that every 4th letter is summed to make the same portion of the hash. I have broken the input into columns and rows to make it easier to visualize. Note that the rows are flipped because of endiannes.
```
F  F  F  F
0  F  F  F
F  0  F  F
F  F  0  F
F  F  F  0

Letters decoded as ints:
46 46 46 46
46 46 46 30
46 46 30 46
46 30 46 46
30 46 46 46

Total:
495f5f5e
```
I then iterated through hashes adjusting each column at a time until I found one that matched.
```
./a.out FAFFFAzFFAZ4FAZ0FAh0
./a.out FgFFFkzFFzZ4FzZ0FBh0
./a.out FgFFFkzFFzZ4FzZ0FBi0
./a.out FgFFFkzFFzZ4FzZ0FBg0
./a.out zgFFFkzFFzZ4FzZ0FBg0
./a.out zgFFFkzFFzZ4FzZ0zBg0
./a.out hgFFzkzFFzZ4FzZ0zBg0
./a.out lgFFzkzFFzZ4FzZ0zBg0
```

```
col@prowl:~$ ./col lgFFzkzFFzZ4FzZ0zBg0
FLAG
```
# Fd
The challenge hint mentions file descriptors. There's a flag file but we can't open it due to file permissions. Theres also a fd executable and fd.c. Listing file permissions shows us that the fd executable and the flag have the same owner `fd_pwn`.
```
-r-sr-x--- 1 fd_pwn fd   7322 Jun 11  2014 fd
-rw-r--r-- 1 root   root  418 Jun 11  2014 fd.c
-r--r----- 1 fd_pwn root   50 Jun 11  2014 flag
```
This means that the fd executable will be able to read the flag.
``` C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char buf[32];
int main(int argc, char* argv[], char* envp[]){
    if(argc<2){
        printf("pass argv[1] a number\n");
        return 0;
    }
    int fd = atoi( argv[1] ) - 0x1234;
    int len = 0;
    len = read(fd, buf, 32);
    if(!strcmp("LETMEWIN\n", buf)){
        printf("good job :)\n");
        system("/bin/cat flag");
        exit(0);
    }
    printf("learn about Linux file IO\n");
    return 0;

}
```
Our first argument gets converted to an integer and 0x1234 is subtracted from it. It is then passed as the first parameter of [read](http://codewiki.wikidot.com/c:system-calls:read). The documentation for `read` states that a file descriptor of 0 causes it to read from standard in which we control! Then `strcmp` checks if the input is equal is to `LETMEWIN\n`. So all we have to do is pass in 4660, which is 0x1234 in decimal, to make the program read from stdin and then type `LETMEWIN`. Which gives us our flag. 
```
fd@ubuntu:~$ ./fd 4660
LETMEWIN
good job :)
FLAG
```