---
title: "Microcorruption"
date: DATE
draft: false
tags: ["reversing"]
description: "Microcoruption: I show you how to solve a series of reverse engineering challenges. Using buffer overflows, breakpoints and guesswork."
reads: 1
---


[Micorruption](ttps://microcorruption.com/) is a series of reverse engineering challenges. It's composed of a series of stages where you have to disable the lock to get to the next stage. Here's how I approached each stage.

# Johannesburg

The overview was:
```
    - A firmware update rejects passwords which are too long.
    - This lock is attached the the LockIT Pro HSM-1.
```
Since the password verification occurs on the hardware module, we have to find another way to exploit it. First, I ran the lock with an input that was longer than the password limit of 16 characters to see what would happen.
```
0123456789101112131415161718192021222324252627
```
We get a message that the password is too long.
```
Invalid Password Length: password too long.
```
Here's the section of assembly that checks if our password is too long:
```
4578:  f190 7e00 1100 cmp.b	#0x7e, 0x11(sp)
457e:  0624           jeq	#0x458c <login+0x60>
4580:  3f40 ff44       mov	#0x44ff "Invalid Password Length: password too long.", r15
4584:  b012 f845      call	#0x45f8 <puts>
4588:  3040 3c44      br	#0x443c <__stop_progExec__>
458c:  3150 1200      add	#0x12, sp
4590:  3041           ret
```
It checks if the password is too long by checking if the value 0x7e has been overwritten in memory. We can bypass this check by writing 0x7e to that address in our payload. We know the stack address at the comparison is `43ec`, by adding 11 to it we get the address of the length check which is `43FD`. We can show where in the payload this is by using the read command. 
```
> read 43fc
   43fc:   2122 2324 2526 2728  !"#$%&'(
   4404:   2930 0001 75f3 35d0  )0..u.5.
   440c:   085a 3f40 0000 0f93  .Z?@....
   4414:   0724 8245 5c01 2f83  .$.E\./.
```
Now we know which location in the payload to replace with `7e`.
```
00000000000000000000000000000000007e00
```
This allows us to bypass the password check. We can then overwrite the return address of login to the address of `<unlock_door>` causing unlock_door to be called.
# Cusco

This stage was a buffer overflow. The overview states:
```
    - We have fixed issues with passwords which may be too long.
    - This lock is attached the the LockIT Pro HSM-1.
```
The password verification occurs on the hardware module. The other part of the overview says that they've fixed issues with too long of passwords. To check this, I ran the lock with a password that was longer than the limit of 16 characters.
```
insn address unaligned
```
This tells us that the CPU is trying to execute invalid instructions which means that we have overwritten the return address on the stack and the CPU is jumping to a bad instruction. By tracing function calls we find that we are overwriting the return address for the `<login>` function.
```
4526:  0524           jz	#0x4532 <login+0x32>
4528:  b012 4644      call	#0x4446 <unlock_door>
452c:  3f40 d144      mov	#0x44d1 "Access granted.", r15
4530:  023c           jmp	#0x4536 <login+0x36>
4532:  3f40 e144      mov	#0x44e1 "That password is not correct.", r15
4536:  b012 a645      call	#0x45a6 <puts>
453a:  3150 1000      add	#0x10, sp
453e:  3041           ret
```
Using the payload `123456789101112131415161718192021222324256`, we find that the values `2122` are what's overwriting the return address. Replacing those values with the address of `<unlock_door>` allows us to unlock the door.
# Reykjavik
In this stage the instructions that check the password are encrypted. The `main` function calls the `enc` function which uses xor to unencrypt the verification instructions. It then jumps to `0x2400` which is the address where these unencrypted instructions are written to. 
```decrypted
4438 <main>
4438:  3e40 2045      mov	#0x4520, r14
443c:  0f4e           mov	r14, r15
443e:  3e40 f800      mov	#0xf8, r14
4442:  3f40 0024      mov	#0x2400, r15
4446:  b012 8644      call	#0x4486 <enc>
444a:  b012 0024      call	#0x2400
444e:  0f43           clr	r15
```
It's not important to understand what `enc` does besides knowing that it decrypts the unlock code. By setting a break point on the return address, we can dump the memory around 0x2400 and disassemble it. To see what it does.
```decrypted
4486 <enc>
4486:  0b12           push	r11
4488:  0a12           push	r10
448a:  0912           push	r9
448c:  0812           push	r8
448e:  0d43           clr	r13
4490:  cd4d 7c24      mov.b	r13, 0x247c(r13)
4494:  1d53           inc	r13
4496:  3d90 0001      cmp	#0x100, r13
449a:  fa23           jne	#0x4490 <enc+0xa>
449c:  3c40 7c24      mov	#0x247c, r12
44a0:  0d43           clr	r13
44a2:  0b4d           mov	r13, r11
44a4:  684c           mov.b	@r12, r8
44a6:  4a48           mov.b	r8, r10
44a8:  0d5a           add	r10, r13
44aa:  0a4b           mov	r11, r10
44ac:  3af0 0f00      and	#0xf, r10
44b0:  5a4a 7244      mov.b	0x4472(r10), r10
44b4:  8a11           sxt	r10
44b6:  0d5a           add	r10, r13
44b8:  3df0 ff00      and	#0xff, r13
44bc:  0a4d           mov	r13, r10
44be:  3a50 7c24      add	#0x247c, r10
44c2:  694a           mov.b	@r10, r9
44c4:  ca48 0000      mov.b	r8, 0x0(r10)
44c8:  cc49 0000      mov.b	r9, 0x0(r12)
44cc:  1b53           inc	r11
44ce:  1c53           inc	r12
44d0:  3b90 0001      cmp	#0x100, r11
44d4:  e723           jne	#0x44a4 <enc+0x1e>
44d6:  0b43           clr	r11
44d8:  0c4b           mov	r11, r12
44da:  183c           jmp	#0x450c <enc+0x86>
44dc:  1c53           inc	r12
44de:  3cf0 ff00      and	#0xff, r12
44e2:  0a4c           mov	r12, r10
44e4:  3a50 7c24      add	#0x247c, r10
44e8:  684a           mov.b	@r10, r8
44ea:  4b58           add.b	r8, r11
44ec:  4b4b           mov.b	r11, r11
44ee:  0d4b           mov	r11, r13
44f0:  3d50 7c24      add	#0x247c, r13
44f4:  694d           mov.b	@r13, r9
44f6:  cd48 0000      mov.b	r8, 0x0(r13)
44fa:  ca49 0000      mov.b	r9, 0x0(r10)
44fe:  695d           add.b	@r13, r9
4500:  4d49           mov.b	r9, r13
4502:  dfed 7c24 0000 xor.b	0x247c(r13), 0x0(r15)
4508:  1f53           inc	r15
450a:  3e53           add	#-0x1, r14
450c:  0e93           tst	r14
450e:  e623           jnz	#0x44dc <enc+0x56>
4510:  3841           pop	r8
4512:  3941           pop	r9
4514:  3a41           pop	r10
4516:  3b41           pop	r11
4518:  3041           ret
```
The dumped memory around `0x2400` is:
```
0b12 0412 0441 2452
3150 e0ff 3b40 2045
073c 1b53 8f11 0f12
0312 b012 6424 2152
6f4b 4f93 f623 3012
0a00 0312 b012 6424
2152 3012 1f00 3f40
dcff 0f54 0f12 2312
b012 6424 3150 0600
b490 e90b dcff 0520
3012 7f00 b012 6424
2153 3150 2000 3441
3b41 3041 1e41 0200
0212 0f4e 8f10 024f
```
Which disassembles to.
```
0b12           push	r11
0412           push	r4
0441           mov	sp, r4
2452           add	#0x4, r4
3150 e0ff      add	#0xffe0, sp
3b40 2045      mov	#0x4520, r11
073c           jmp	$+0x10
2152           add	#0x4, sp
6f4b           mov.b	@r11, r15
4f93           tst.b	r15
f623           jnz	$-0x12
3012 0a00      push	#0xa
0312           push	#0x0
b012 6424      call	#0x2464
2152           add	#0x4, sp
3012 1f00      push	#0x1f
3f40 dcff      mov	#0xffdc, r15
0f54           add	r4, r15
0f12           push	r15
2312           push	#0x2
b012 6424      call	jmp return
3150 0600      add	#0x6, sp
b490 e90b dcff cmp	#0xbe9, -0x24(r4)
0520           jnz	$+0xc
3012 7f00      push	#0x7f
b012 6424      call	#0x2464
2153           incd	sp
3150 2000      add	#0x20, sp
3441           pop	r4
3b41           pop	r11
3041           ret
```
These unencrypted instructions checks that the first byte of password is equal to `0xbe9`. 
```
b490 e90b dcff cmp	#0xbe9, -0x24(r4)
0520           jnz	$+0xc
3012 7f00      push	#0x7f
b012 6424      call	#0x2464
```
We can then use that value as our password. It's order is flipped because of endianness `e90b`.
# Hanoi
My approach for solving this stage was to focus on the instructions that reference the area of memory the password is stored in. The login function calls `test_password_valid` which is a decoy. It doesn't access the memory the password is stored in, so we know that it can't be checking the password.
```
4520 <login>
4520:  c243 1024      mov.b	#0x0, &0x2410
4524:  3f40 7e44      mov	#0x447e "Enter the password to continue.", r15
4528:  b012 de45      call	#0x45de <puts>
452c:  3f40 9e44      mov	#0x449e "Remember: passwords are between 8 and 16 characters.", r15
4530:  b012 de45      call	#0x45de <puts>
4534:  3e40 1c00      mov	#0x1c, r14
4538:  3f40 0024      mov	#0x2400, r15
453c:  b012 ce45      call	#0x45ce <getsn>
4540:  3f40 0024      mov	#0x2400, r15
4544:  b012 5444      call	#0x4454 <test_password_valid>
4548:  0f93           tst	r15
454a:  0324           jz	$+0x8
454c:  f240 9a00 1024 mov.b	#0x9a, &0x2410
4552:  3f40 d344      mov	#0x44d3 "Testing if password is valid.", r15
4556:  b012 de45      call	#0x45de <puts>
455a:  f290 7700 1024 cmp.b	#0x77, &0x2410
4560:  0720           jne	#0x4570 <login+0x50>
4562:  3f40 f144      mov	#0x44f1 "Access granted.", r15
4566:  b012 de45      call	#0x45de <puts>
456a:  b012 4844      call	#0x4448 <unlock_door>
456e:  3041           ret
4570:  3f40 0145      mov	#0x4501 "That password is not correct.", r15
4574:  b012 de45      call	#0x45de <puts>
4578:  3041           ret
```
The actual password validation occurs in login.
```
455a:  f290 7700 1024 cmp.b	#0x77, &0x2410
4560:  0720           jne	#0x4570 <login+0x50>
```
All it does is check that the 16th byte of password is 77. By setting that byte to 77 we solve this stage.
# Sydney 
In this stage the password was stored in the instructions themselves.
```
448a:  bf90 6259 0000 cmp	#0x5962, 0x0(r15)
4490:  0d20           jnz	$+0x1c
4492:  bf90 5253 0200 cmp	#0x5352, 0x2(r15)
4498:  0920           jnz	$+0x14
449a:  bf90 6321 0400 cmp	#0x2163, 0x4(r15)
44a0:  0520           jne	#0x44ac <check_password+0x22>
44a2:  1e43           mov	#0x1, r14
44a4:  bf90 6d4d 0600 cmp	#0x4d6d, 0x6(r15)
44aa:  0124           jeq	#0x44ae <check_password+0x24>
44ac:  0e43           clr	r14
44ae:  0f4e           mov	r14, r15
```
This code checks each part of our password against the values in the cmp instructions. It checks that `5962` was the first thing read onto our stack. Since the machine is little endian, this is when the least significant bytes are stored first in memory, when inputting values we have to flip the bytes to get `6259`. By putting all the values in the cmp instructions together we get our password.
# New Orleans 
In this stage the password is created in the `create_password` function. 
```
447e <create_password>
447e:  3f40 0024      mov	#0x2400, r15
4482:  ff40 3800 0000 mov.b	#0x38, 0x0(r15)
4488:  ff40 6000 0100 mov.b	#0x60, 0x1(r15)
448e:  ff40 7c00 0200 mov.b	#0x7c, 0x2(r15)
4494:  ff40 7200 0300 mov.b	#0x72, 0x3(r15)
449a:  ff40 2700 0400 mov.b	#0x27, 0x4(r15)
44a0:  ff40 2500 0500 mov.b	#0x25, 0x5(r15)
44a6:  ff40 4700 0600 mov.b	#0x47, 0x6(r15)
44ac:  cf43 0700      mov.b	#0x0, 0x7(r15)
44b0:  3041           ret
```
The `check_password` function reads our constructed password off of the stack. `Check_password` then compares our password to the password we put in.
```
44bc <check_password>
44bc:  0e43           clr	r14
44be:  0d4f           mov	r15, r13
44c0:  0d5e           add	r14, r13
44c2:  ee9d 0024      cmp.b	@r13, 0x2400(r14)
44c6:  0520           jne	#0x44d2 <check_password+0x16>
44c8:  1e53           inc	r14
44ca:  3e92           cmp	#0x8, r14
44cc:  f823           jne	#0x44be <check_password+0x2>
44ce:  1f43           mov	#0x1, r15
```
We construct the password by putting the bytes in the move instructions together.
