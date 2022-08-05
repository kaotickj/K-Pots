[![Actively Maintained](https://img.shields.io/badge/Maintenance%20Level-Actively%20Maintained-green.svg)](https://gist.github.com/cheerfulstoic/d107229326a01ff0f333a1d3476e068d) [![Version-0.1](https://img.shields.io/badge/Version-0.1-green)](https://img.shields.io/badge/Version-0.1-green) [![License MIT](https://img.shields.io/badge/License-MIT-blue)](https://github.com/kaotickj/K-Pots/blob/main/LICENSE) [![Language BASH](https://img.shields.io/badge/Language-BASH-red)](https://www.gnu.org/software/bash/)

![Logo](https://kdgwebsolutions.com/assets/img/k-pots.png)
# K Pots
## 🕵🔎 By KaotickJ 👽 

 KPots is a simple honeypots system to capture and log traffic to specified ports.

 Syntax: kpots.sh [-h|-d|-b|-m|-l|-s|-v] \<PORT\>

   options:
   -------------------------------------------
   * -h Show this help message
   * -d <PORT> Deletes ALL logs for ALL ports.
   * -b <PORT> Generates a new banner for port specified .
   * -m <PORT> Only monitor specified port. No logs
   * -l <PORT> Read the logs
   * -s <PORT> To monitor specified port in simple mode
   * -v <PORT> To monitor specified port in verbose mode
### Usage
>  PLEASE NOTE:  K-Pots MUST be run with elevated privileges. Run as root or `sudo ./kpots.sh `

First, you'll need a banner for the port.  K-pots displays the banner text at $DIR/$PORT.txt on connect. To generate a new banner for a port, for example, ssh on port 22  simply run:
```sh
sudo ./kpots.sh -b 22
```
You will have options to use the default banner template:
> Port $PORT
  Powered by KPots
  🕵🔎 Courtesy of KaotickJ 👽

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

 
🕵🔎 Courtesy of KaotickJ 👽

![Hack The Box](http://www.hackthebox.eu/badge/image/476578)
