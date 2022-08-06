[![Actively Maintained](https://img.shields.io/badge/Maintenance%20Level-Actively%20Maintained-green.svg)](https://gist.github.com/cheerfulstoic/d107229326a01ff0f333a1d3476e068d) [![Version-0.1](https://img.shields.io/badge/Version-0.1-green)](https://img.shields.io/badge/Version-0.1-green) [![License MIT](https://img.shields.io/badge/License-MIT-blue)](https://github.com/kaotickj/K-Pots/blob/main/LICENSE) [![Language BASH](https://img.shields.io/badge/Language-BASH-red)](https://www.gnu.org/software/bash/)

![Logo](https://kdgwebsolutions.com/assets/img/kpots-cover.png)
# K Pots
## 🕵🔎 By KaotickJ 👽 

 KPots is a simple honeypots system to capture, log, and ban traffic to specified ports.

 Syntax: kpots.sh [-h|-d|-b|-m|-l|-s|-v|-x] \<PORT\>

   options:
   -------------------------------------------
   * -h Show this help message
   * -b <PORT> Generates a new banner for port specified .
   * -l Read the logs
   * -m <PORT> Only monitor specified port. No logs
   * -p Parse and sort ip addresses from logs
   * -s <PORT> To monitor specified port in simple mode
   * -v <PORT> To monitor specified port in verbose mode
   * -x To ban offending IPs
### Usage
>  PLEASE NOTE:  K-Pots MUST be run with elevated privileges. Run as root or `sudo ./kpots.sh `

First, you'll need a banner for the port.  K-pots displays the banner text at $DIR/$PORT.txt on connect. To generate a new banner for a port, for example, ssh on port 22  simply run:
```sh
sudo ./kpots.sh -b 22
```
You will have options to use the default banner template:
> * Port $PORT
* Powered by KPots
* 🕵🔎 Courtesy of KaotickJ 👽

Or to create a custom one. For more authenticity to the *attacker, it is best to use a custom banner specifically mimmicking any services tied to the given port. 

##### Manual Banner Creation 
If you don't want to use the generator, create port#.txt and save your own banner text into it:
```sh
touch port#.txt
nano port#.txt
```
#### A realistic ssh banner:
>The authenticity of host '10.0.2.41 (10.0.2.41)' can't be established.
ED25519 key fingerprint is SHA256:1r8zd7E92Jq4/fDkEXzkFJ5RlQ25g1dPA5edubA1L/U.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])?

## Monitor Modes
Kpots has 3 monitoring modes, Simple, Verbose, and Monitor Only
#### Simple Monitoring Mode

> Simple Monitoring Mode listens for connections and logs output to a file.  It does not display connections in the terminal, and is useful for monitoring ports in the background.  Logs are stored in ./pots/s-mode.log and are base64 encoded to reduce filesize.

To monitor ssh port 22 for incoming connections and log traffic to ./pots/s-mode.log:
```sh
sudo ./kpots.sh -s 22
```
To view Simple Mode logs:
##### Method 1
```sh
cat <./pots/s-mode.log | bae64 -d
```

##### Method 2
```sh
sudo ./kpots.sh -l
```
Choose option 1 - "Logs From Simple Mode"

### Verbose Monitoring Mode
> Verbose Monitoring Mode listens for connections displays them in the terminal, and logs output to a file. Logs are stored in ./pots/v-mode.log and are base64 encoded to reduce filesize.

To monitor port 22 for incoming connections, display them in the terminal, and log traffic to ./pots/v-mode.log:
```sh
sudo ./kpots.sh -v 22
```
To view Verbose Mode logs:
##### Method 1
```sh
cat <./pots/v-mode.log | bae64 -d
```

##### Method 2
```sh
sudo ./kpots.sh -l
```
Choose option 2 - "Logs From Verbose Mode"

### Monitor Only Mode
> Monitor Only Mode listens for connections and displays them in the terminal.  It does not output any logs. It's purpose is for real-time monitoring only.

To monitor port 22 for incoming connections and display them in the terminal, but create no logs:
```sh
sudo ./kpots.sh -v 22
```

## Ban Offending IPs
> Banning IPs that have been captured to kpots logs is a three step process. It's designed this way so that you have an opportunity to check the logs before banning to assure that your own IP(s) are not getting banned. To ban offending IPs:
##### Steps:
1) Run the log parser to extract the IP addresses from the logs:
```sh
sudo ./kpots.sh -p
```
2) IP addresses will be saved to ./pots/offending-ips.log Examine the file to be sure that all IPs listed should be banned.  It is an absolute pain in the you know what if you ban your own ip address. Because the file was created with kpots running as root, you'll possibly need to edit it as root. Delete any IP addresses that belong to your devices or to your subnet. If you are unsure what this means, don't use this feature until you have learned how to determine what addresses are your own. Once you have closely inspected the IP log and are absolutely certain that you want to block everything listed:
3) Run the IP Blocker 
```sh
sudo ./kpots.sh -x
```
 If there are no errors, the offending IP addresses were successfully banned.
 
🕵🔎 Courtesy of KaotickJ 👽

![Hack The Box](http://www.hackthebox.eu/badge/image/476578)
