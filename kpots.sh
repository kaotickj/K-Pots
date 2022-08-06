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
PORT=$2 

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

###########################
#  LOG READER
###########################
logreader()
{
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}          📖        Reading Logs         📖          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  PS3="${YELLOW}What do you want to do? (1=Simple 2=Verbose 3=Logs Menu 5=QUIT)" 
  options=("Logs From Simple Mode" "Logs From Verbose Mode" "This Menu" "Archive Logs" "Quit")
  select opt in "${options[@]}"
  do
    case $opt in
	"Logs From Simple Mode")
	  if [ -f $DIR/s-mode.log ]
	    then
              cat <$DIR/s-mode.log | base64 -d
	    else
	      echo -e ${RED}'---> No simple mode logs yet'     
	  fi
	;;
	"Logs From Verbose Mode")
	  if [ -f $DIR/v-mode.log ]
	    then
              cat <$DIR/v-mode.log | base64 -d
	    else
	      echo -e ${RED}'---> No verbose mode logs yet'     
	  fi
	;;
	"This Menu")
	   clear		
	   logreader
	;;   
	"Archive Logs")
          mkdir -p $DIR/archive	
	  echo "${YELLOW}--->Archiving Logs ....."
	  if [ -f pots/s-mode.log ] || [ -f pots/v-mode.log ]
	    then
	      tar -cvzf kpots_logs_$now.tar.gz pots/*.log
              mv kpots_logs_$now.tar.gz $DIR/archive/kpots_logs_$now.tar.gz
              rm $DIR/*.log
	      echo
	      echo "${GREEN}--->Finished archiving. Moved to $DIR/archive/kpots_logs_$now.tar.gz"
	    else
	      echo -e ${RED}'---> Nothing to do'     
	  fi
	;;
	"Quit")
	  echo "${LIGHT_MAGENTA}     👋   Goodbye, and Thanks for using Kpots   👋"
#	  if [ -f pots/offending-ips.log ]
#	    then
#	      rm $DIR/offending-ips.log
#	  fi
	  exit;;
    esac
  done  	
}

###########################
# PORT BANNER GENERATOR
###########################
bannergen()
{
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}          ⚙️    Port Banner Generator    ⚙️          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to generate banner for ' PORT
  fi 
  PS3="${YELLOW}Type of banner to generate? (3=QUIT)" 

  options=("Custom_Banner" "Default_Banner" "Quit")
  select opt in "${options[@]}"
  do
    case $opt in
      "Custom_Banner")
	read -p 'Set custom banner text ' BANNER
        echo $BANNER > $DIR/$PORT.txt
        echo "${YELLOW}Finished. Banner for port $PORT set to:${GREEN}"
        echo
        cat $DIR/$PORT.txt
        sleep 2
	echo "Your banner for port $PORT is set.  You're ready to monitor it."	
	echo "${DG}-->sudo ./kpots.sh [-s|-v] $PORT to start monitoring."	
	exit
      ;;
      "Default_Banner")
        echo "Port $PORT" > $DIR/$PORT.txt
        echo "Powered by KPots" >> $DIR/$PORT.txt
        echo "" >> $DIR/$PORT.txt
        echo "🕵🔎 Courtesy of KaotickJ 👽" >> $DIR/$PORT.txt 
        echo "" >> $DIR/$PORT.txt
        echo "${YELLOW}Finished. Banner for port $PORT set to:${GREEN}"
	echo
        cat $DIR/$PORT.txt
	sleep 2
	echo "Your banner for port $PORT is set.  You're ready to monitor it."
	echo "${DG}-->sudo ./kpots.sh [-s|-v] $PORT to start monitoring."
	exit	
      ;;
      "Quit")
	echo "${LIGHT_MAGENTA}     👋   Goodbye, and Thanks for using Kpots   👋"
#	if [ -f pots/offending-ips.log ]
#	  then
#	    rm $DIR/offending-ips.log
#	fi
	exit
      ;;  
    esac
  done		
  clear
}

####################
#  SIMPLE
####################
simple()
{
  if [ ! -f pots/s-mode.log ]
    then
      touch pots/s-mode.log
  fi
  if [ ! -f pots/$PORT.txt ]
    then 
      echo "${RED}  💀 You don't have a banner for port $PORT sudo ./kpots.sh -b $PORT to create one. 💀"
      exit 
   else
      echo -e ${YELLOW}'---> Starting ...'     
  fi
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}         🤬    Simple Mode Monitoring    🤬          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to monitor ' PORT
  fi 
  echo -ne ${YELLOW}'Monitoring Port ' $PORT'\r'
  sleep .5
  echo -ne ${DG}'---> Monitoring Port ' $PORT'\n'
  echo -e "" | base64 >>$DIR/s-mode.log 
  echo -e "HoneyPot Started on port $PORT $(date)." | base64 >>$DIR/s-mode.log 
  echo ${DG}'---> Logs saving to ' $DIR/s-mode.log''
  echo '---> (hit ctrl c twice to end)'
  sleep .2
  while :
    do
      echo "" >>$DIR/$PORT.log;
      sudo nc -lvnp $PORT < $DIR/$PORT.txt 1>>$DIR/$PORT.log 2>>$DIR/$PORT.log;
      echo $(date) >> $DIR/$PORT.log;
      cat $DIR/$PORT.log | base64 >>$DIR/s-mode.log
      rm $DIR/$PORT.log	
      sleep 2
    done
}

####################
#  VERBOSE
####################
verbose()
{
  if [ ! -f pots/v-mode.log ]
    then
      touch pots/v-mode.log
  fi
  if [ ! -f pots/$PORT.txt ]
    then 
      echo "${RED}  💀 You don't have a banner for port $PORT sudo ./kpots.sh -b $PORT to create one. 💀"
      exit 
   else
      echo -e ${YELLOW}'---> Starting ...'     
  fi
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}          🤑    Verbose Mode Moitoring    🤑         "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to monitor ' PORT
  fi 
  echo -e "${YELLOW}Logging to ${DG}$DIR/v-mode.log"
  echo -e "${GREEN}---> HoneyPot Started on port $PORT $(date)."
  echo -e "" >>$DIR/v-mode.log 
  echo -e "HoneyPot Started on port $PORT $(date)." | base64 >>$DIR/v-mode.log 
  while :
    do
      echo "" >$DIR/$PORT.log;
      sudo nc -lvnp $PORT < $DIR/$PORT.txt 1>>$DIR/$PORT.log 2>>$DIR/$PORT.log;
      echo $(date) >> $DIR/$PORT.log;
      cat $DIR/$PORT.log | base64 >>$DIR/v-mode.log
      echo
      echo "${RED}Hit from:${DG}"
      cat $DIR/$PORT.log
      rm $DIR/$PORT.log
      sleep 2
    done
}

#########################
# MONITORING ONLY
#########################
nologs()
{
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}         😶    No Logs / Monitor Only    😶          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to monitor ' PORT
  fi 
  echo -e "${GREEN}---> HoneyPot Started on port $PORT $(date)."
  while :
    do
      echo
      sudo nc -lvnp $PORT < $DIR/$PORT.txt 1>>$DIR/$PORT.log 2>>$DIR/$PORT.log;
      echo "${RED}Hit from:${DG}"
      cat $DIR/$PORT.log
      rm $DIR/$PORT.log
      echo
      sleep 2
    done
}

########################
# PARSE AND SORT LOGS
########################
parselogs()
{
  if [ -f pots/s-mode.log ] || [ -f pots/v-mode.log ]
    then
      echo "${BLUE}-----------------------------------------------------"
      echo "${BLUE}        📀    Parsing and Sorting Logs    📀         "
      echo "${BLUE}-----------------------------------------------------"
      cat <$DIR/s-mode.log | base64 -d > converted.log
      cat converted.log | grep -oa '[1-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq > offender-ips.log
      rm converted.log
      cat <$DIR/v-mode.log | base64 -d >> converted.log
      cat converted.log | grep -oa '[1-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq >> offender-ips.log
      rm converted.log
      cat offender-ips.log | sort | uniq > $DIR/offending-ips.log
      rm offender-ips.log
      echo "${RED}OFFENDING IPS: ${LIGHT_MAGENTA}"
      cat $DIR/offending-ips.log
      echo "${DG}---> Offending IPs saved to $DIR/offending-ips.log"
      echo "${GREEN}Finshed parsing logs"
      exit
    else
      echo -e ${RED}'---> Nothing to do'     
  fi  
}

##########################
# BAN OFFENDING IPS
##########################

ban()
{
echo ${BLUE}
  if [ -f pots/offending-ips.log ]
    then
    	echo "${RED} ⚠️  STOP! VIEW THE IP LOG AND EDIT OUT ANY IPs ⚠️" 
    	echo "     YOU DON'T WANT TO BAN BEFORE CONTINUING "
	tput sgr0 
	echo ${BLUE}
	read -n1 -p "View the log first? (n bans all logged IPs) [y,n]" viewem 
	case $viewem in  
	  y|Y)
	     if command -v gedit > /dev/null;
	       then
	        gedit pots/offending-ips.log;
	       else
	        nano pots/offending-ips.log; 
             fi
	     ban
	  ;; 
	  n|N)
	      echo "${BLUE}-----------------------------------------------------"
	      echo "${BLUE}        🚫     Banning Offending IPs     🚫          "
	      echo "${BLUE}-----------------------------------------------------"
	      for i in `cat $DIR/offending-ips.log|grep -v "#"`
	      do
		ADDR=$i
		/sbin/iptables -t filter -I INPUT -s $ADDR -j DROP
		/sbin/iptables -t filter -I OUTPUT -s $ADDR -j DROP
		/sbin/iptables -t filter -I FORWARD -s $ADDR -j DROP
		/sbin/iptables -t filter -I INPUT -d $ADDR -j REJECT
		/sbin/iptables -t filter -I OUTPUT -d $ADDR -j REJECT
		/sbin/iptables -t filter -I FORWARD -d $ADDR -j REJECT
		echo "👊 Blocked all connections from $ADDR "
	      done
	      rm $DIR/offending-ips.log
	  ;; 
          *)
	      echo "💀 invalid option ./kpots.sh -h for help 💀"
          ;; 
	esac
    else
      echo -e ${RED}'---> Nothing to do'     
  fi
}

##########################
# OFFENDING IPS WHOIS
##########################

whoare()
{
  if [ -f pots/offending-ips.log ]
    then
      echo "##########################################" > $DIR/whois-$now.log
      echo "# 🦉WHOIS Info for Offending IPS Follows #" >> $DIR/whois-$now.log
      echo "##########################################" >> $DIR/whois-$now.log
      echo "# Scan time: " $dt>> $DIR/whois-$now.txt	
      echo "------------------------------------------">>$DIR/whois-$now.log
      echo "" >> $DIR/whois-$now.log
      echo "${BLUE}-----------------------------------------------------"
      echo "${BLUE}        🦉      Offending IPs Whois      🦉          "
      echo "${BLUE}-----------------------------------------------------"
      for i in `cat $DIR/offending-ips.log|grep -v "#"`
      do
        ADDR=$i
        echo "#  WHOIS FOR $ADDR:  " >>$DIR/whois-$now.log
        echo "##########################################" >> $DIR/whois-$now.log
	whois $ADDR >> $DIR/whois-$now.log
        echo "${DG} ---> 🦉 Whois for $ADDR done. Saved to $DIR/whois-$now.log "
      done
    else
      echo -e ${RED}'---> Nothing to do'     
  fi
}

#########################
#  DELETE
#########################
#delete()
#{
#  if [ -z "${PORT}" ];
#   then	
#     read -p #'Set Port # to monitor ' PORT
# fi 
# rm $DIR/*.log
#  sleep 1
#  echo "${DG}--->$DIR/*.log deleted"
#}

#########################
#  HELP
#########################
Help()
{
resize -s 30 60
clear
echo "    ${RED} _____  __${LIGHT_MAGENTA} ____       _        "
echo "    ${RED} ___| |/ /${LIGHT_MAGENTA}|  _ \ ___ | |_ ___  "
echo "    ${RED} ___| ' / ${LIGHT_MAGENTA}| |_) / _ \| __/ __|"
echo "    ${RED} ___| . \ ${LIGHT_MAGENTA}|  __/ (_) | |_\__ \\"
echo "    ${RED} ___|_|\_\\${LIGHT_MAGENTA}|_|   \___/ \__|___/"
echo
echo "         ${GREEN}   🕵🔎 By KaotickJ 👽 " 
echo 
                 
echo " ${BLUE}KPots is a simple honeypots system to capture and log traffic to specified ports."
echo
   echo " ${LIGHT_MAGENTA}Syntax: kpots.sh [-h|-b|-H|-l|-m|-p|-s|-v] ${YELLOW}<PORT>"
   echo ${GREEN}
   echo " options:"
   echo " -------------------------------------------"
   echo " ${YELLOW}-h ${BLUE}Show this help message"
   echo " ${YELLOW}-b ${YELLOW}<PORT>${BLUE} Generates a new banner for port specified ."
   echo " ${YELLOW}-H ${BLUE} Offending IPs Whois"
   echo " ${YELLOW}-l ${BLUE} Read the logs"
   echo " ${YELLOW}-m ${YELLOW}<PORT>${BLUE} Only monitor specified port. No logs"
   echo " ${YELLOW}-p ${BLUE} Parse and sort ip addresses from logs"
   echo " ${YELLOW}-s ${YELLOW}<PORT>${BLUE} To monitor specified port in simple mode"
   echo " ${YELLOW}-v ${YELLOW}<PORT>${BLUE} To monitor specified port in verbose mode"
   echo " ${YELLOW}-x ${BLUE} To ban offending IPs"
   echo 
#   sleep 3	
}


################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

[[ `id -u` -eq 0 ]] || { echo -e "${RED}💀 Must run as root (sudo ./ksploit.sh) 💀"; exit 1; }
resize -s 30 60
clear
echo "    ${RED} _____  __${LIGHT_MAGENTA} ____       _        "
echo "    ${RED} ___| |/ /${LIGHT_MAGENTA}|  _ \ ___ | |_ ___  "
echo "    ${RED} ___| ' / ${LIGHT_MAGENTA}| |_) / _ \| __/ __|"
echo "    ${RED} ___| . \ ${LIGHT_MAGENTA}|  __/ (_) | |_\__ \\"
echo "    ${RED} ___|_|\_\\${LIGHT_MAGENTA}|_|   \___/ \__|___/"
echo
echo "         ${GREEN}   🕵🔎 By KaotickJ 👽 " 
echo 
                 
echo " ${BLUE}KPots is a simple honeypots system to capture and log traffic to specified ports."
echo
   echo " ${LIGHT_MAGENTA}Syntax: kpots.sh [-h|-b|-H|-l|-m|-p|-s|-v] ${YELLOW}<PORT>"
   echo ${GREEN}
   echo " options:"
   echo " -------------------------------------------"
   echo " ${YELLOW}-h ${BLUE}Show this help message"
   echo " ${YELLOW}-b ${YELLOW}<PORT>${BLUE} Generates a new banner for port specified ."
   echo " ${YELLOW}-H ${BLUE} Offending IPs Whois"
   echo " ${YELLOW}-l ${BLUE} Read the logs"
   echo " ${YELLOW}-m ${YELLOW}<PORT>${BLUE} Only monitor specified port. No logs"
   echo " ${YELLOW}-p ${BLUE} Parse and sort ip addresses from logs"
   echo " ${YELLOW}-s ${YELLOW}<PORT>${BLUE} To monitor specified port in simple mode"
   echo " ${YELLOW}-v ${YELLOW}<PORT>${BLUE} To monitor specified port in verbose mode"
   echo " ${YELLOW}-x ${BLUE} To ban offending IPs"
   echo 

while getopts ":h?:b?:H?:l?:m?:p?:s?:v?:x?" opt; 
do
  case "$opt" in
       h) Help
         exit;;
       b) bannergen
         ;;
       H) whoare       
         ;;
       l) logreader
	 ;; 
       m) nologs
	 ;;
       p) parselogs       
         ;;	 
       s) simple
         ;;
       v) verbose
         ;;
       x) ban
         ;;
       *) 
         echo ${RED}
         echo "💀 invalid option ./kpots.sh -h for help 💀"
         exit;;
    esac
done
echo "${LIGHT_MAGENTA}     👋   Goodbye, and Thanks for using Kpots   👋"
#if [ -f pots/offending-ips.log ]
#  then
#    rm $DIR/offending-ips.log
#fi
tput sgr0 
