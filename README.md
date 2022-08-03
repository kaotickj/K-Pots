[![Actively Maintained](https://img.shields.io/badge/Maintenance%20Level-Actively%20Maintained-green.svg)](https://gist.github.com/cheerfulstoic/d107229326a01ff0f333a1d3476e068d) [![Version-0.1](https://img.shields.io/badge/Version-0.1-green)](https://img.shields.io/badge/Version-0.1-green) [![License MIT](https://img.shields.io/badge/License-MIT-blue)](https://github.com/kaotickj/K-Pots/blob/main/LICENSE) [![Language BASH](https://img.shields.io/badge/Language-BASH-red)](https://www.gnu.org/software/bash/)

![Logo](https://kdgwebsolutions.com/assets/img/kpots.png)
# K Pots
## 🕵🔎 By KaotickJ 👽 
KPots is a simple honeypots system to capture and log traffic to specified ports.

Syntax: kpots.sh [-h|-d|-i|-s|-v] <PORT>

   options:
   -------------------------------------------
*   -h help message
*   -d <PORT> Deletes logs for specified port.
*   -i <PORT> Generates a new banner for port specified .
*   -s <PORT> To monitor specified port in simple mode.
*   -v <PORT> To monitor soecified port in verbose mode.
### Usage
>  PLEASE NOTE:  K-Pots MUST be run with elevated privileges. Run as root or `sudo ./kpots.sh `

First, you'll need a banner for the port.  K-pots displays the banner text at $DIR/$PORT.txt on connect. 
To generate a new banner for a port, for example, ssh on port 22  simply run:
```sh
sudo ./kpots.sh -i 22
```
To monitor port 22 for incoming connections and log traffic to 22.log:
```sh
sudo ./kpots.sh -s 22
```
To monitor port 22 for incoming connections, display them in the terminal, and log traffic to $DIR/$PORT/long.log:
```sh
sudo ./kpots.sh -v 22
```
To delete logs for port 22:
```sh
sudo ./kpots.sh -d 22
```

🕵🔎 Courtesy of KaotickJ 👽

![Hack The Box](http://www.hackthebox.eu/badge/image/476578)
