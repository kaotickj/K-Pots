#! /bin/bash
# Script: kpots.sh v 0.1
# Author: kaotickj
# Website: kdgwebsolutions.com

###################
#  VARS
###################
now=$(date +"%m_%d_%Y")
dt=$(date '+%d-%m-%Y-%H:%M:%S');
DIR=$(pwd)'/pots'
IP2BAN=$1 
mkdir -p logs
LOGDIR=$(pwd)/logs

####################
#  COLORS
####################
C=$(printf '\033')
RED="${C}[1;31m"
SED_RED="${C}[1;31m&${C}[0m"
GREEN="${C}[1;32m"
SED_GREEN="${C}[1;32m&${C}[0m"
YELLOW="${C}[1;33m"
SED_YELLOW="${C}[1;33m&${C}[0m"
SED_RED_YELLOW="${C}[1;31;103m&${C}[0m"
BLUE="${C}[1;34m"
SED_BLUE="${C}[1;34m&${C}[0m"
ITALIC_BLUE="${C}[1;34m${C}[3m"
LIGHT_MAGENTA="${C}[1;95m"
SED_LIGHT_MAGENTA="${C}[1;95m&${C}[0m"
LIGHT_CYAN="${C}[1;96m"
SED_LIGHT_CYAN="${C}[1;96m&${C}[0m"
LG="${C}[1;37m" #LightGray
SED_LG="${C}[1;37m&${C}[0m"
DG="${C}[1;90m" #DarkGray
SED_DG="${C}[1;90m&${C}[0m"
NC="${C}[0m"
UNDERLINED="${C}[5m"
ITALIC="${C}[3m"
if [ -z "${IP2BAN}" ];
  then	
    read -p "Enter the ip addy or cidr to block " IP2BAN
fi
ADDR=$IP2BAN
/sbin/iptables -t filter -I INPUT -s $ADDR -j DROP
/sbin/iptables -t filter -I OUTPUT -s $ADDR -j DROP
/sbin/iptables -t filter -I FORWARD -s $ADDR -j DROP
/sbin/iptables -t filter -I INPUT -d $ADDR -j REJECT
/sbin/iptables -t filter -I OUTPUT -d $ADDR -j REJECT
/sbin/iptables -t filter -I FORWARD -d $ADDR -j REJECT
echo $ADDR >> $LOGDIR/blocked-ips.log
cat $LOGDIR/blocked-ips.log | sort | uniq >> blocked-ips.log
mv blocked-ips.log $LOGDIR/blocked-ips.log
echo "${GREEN} ---> 🚫 Blocked all connections from${RED}" $ADDR 


tput sgr0


