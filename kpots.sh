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
mkdir -p logs
LOGDIR=$(pwd)/logs
THISIP=$(dig @resolver4.opendns.com myip.opendns.com +short -4)

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
if [ -f block-banned.sh ]
  then
      echo "${YELLOW}  You have previously banned offenders."
      read -n1 -p "Do you want to automatically ban them now? [y,n]" banem
      case $banem in  
	y|Y)
	  	sudo ./block-banned.sh
	  exit
	;; 
	n|N)
#	  mv block-banned.sh $LOGDIR/block-banned.sh
#	  exit
 	;;
    *)
     echo ${RED}
     echo "💀 invalid option ./kpots.sh -h for help 💀"
     exit
    ;; 
  esac
fi
###########################
#  LOG READER
###########################
logreader()
{
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}          📜        Reading Logs         📜          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  PS3="${YELLOW}What do you want to do? (1=View 2=Archives 3=Logs Menu 4=QUIT)" 
  options=("View Logs" "View Archived" "This Menu" "Quit") #"Logs From Verbose Mode" "Archive Logs" 
  select opt in "${options[@]}"
  do
    case $opt in
	"View Logs")
	  if [ -f $DIR/s-mode.log ]
	    then
              cat <$DIR/s-mode.log | base64 -d
	    else
	      echo -e ${RED}'---> No simple mode logs yet'     
	  fi
	;;
	"Logs From Verbose Mode")
	  if [ -f $DIR/archive/activity.log ]
	    then
             cat <$DIR/archive/activity.log | base64 -d
	    else
	      echo -e ${RED}'---> No archived logs yet'     
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
              mv kpots_logs_$now.tar.gz $DIR/archive/kpots_logs_$dt.tar.gz
              rm $DIR/*.log
	      echo
	      echo "${GREEN}--->Finished archiving. Saved to $DIR/archive/kpots_logs_$dt.tar.gz"
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
      echo "${RED}  💀 You do not have a banner for port $PORT sudo ./kpots.sh -b $PORT to create one. 💀"
      echo ${YELLOW}
      read -n1 -p "Create it now (you can't monitor port $PORT until you do) [y,n]" makeflag
      case $makeflag in  
	y|Y)
	  sudo bash kpots.sh -b $PORT
	  simple
	;; 
	n|N)
	  echo "${LIGHT_MAGENTA}     👋   Goodbye, and Thanks for using Kpots   👋"
	  exit
 	;;
        *)
         echo ${RED}
         echo "💀 invalid option ./kpots.sh -h for help 💀"
         exit
        ;; 
      esac
   else
      echo -e ${YELLOW}'---> Starting ...'     
  fi
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}         🖋️     Logging Only Mode      🖋️            "
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
  echo -e "KPot Started on port $PORT $(date)." | base64 >>$DIR/s-mode.log 
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
#  Auto Blocking 
####################
verbose()
{
  if [ ! -f pots/v-mode.log ]
    then
      touch pots/v-mode.log
  fi
  if [ ! -f pots/$PORT.txt ]
    then 
      echo "${RED}  💀 You do not have a banner for port $PORT sudo ./kpots.sh -b $PORT to create one. 💀"
      echo ${YELLOW}
      read -n1 -p "Create it now (you can't monitor port $PORT until you do) [y,n]" makeflag
      case $makeflag in  
	y|Y)
	  sudo bash kpots.sh -b $PORT
	  verbose
	;; 
	n|N)
	  echo "${LIGHT_MAGENTA}     👋   Goodbye, and Thanks for using KPots   👋"
	  exit
 	;;
        *)
         echo ${RED}
         echo "💀 invalid option ./kpots.sh -h for help 💀"
         exit
        ;; 
      esac
   else
      echo -e ${YELLOW}'---> Starting ...'     
  fi
  if [ ! -f pots/v-mode.log ]
    then
      touch $DIR/v-mode.log
  fi
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}          🚫     Auto  Blocking Mode      🚫         "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to monitor ' PORT
  fi 
  echo -e "${YELLOW}Automatically banning ${RED} All Offenders"
  echo -e "${GREEN}---> KPot Started on port $PORT $(date)."
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
  if [ -f pots/v-mode.log ]
    then
      cat <$DIR/v-mode.log | base64 -d >> converted.log
      cat converted.log | grep -oa '[1-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq >> offender-ips.log
      rm converted.log
      cat offender-ips.log | sort | uniq > $DIR/offending-ips.log
      rm offender-ips.log
      if [ -f pots/v-mode.log ]
        then    
          cat <$DIR/v-mode.log >> $LOGDIR/activity.log
          rm $DIR/v-mode.log
      fi
      echo "##########################################" >> $LOGDIR/whois-v-mode.txt
      echo "# 🦉WHOIS Info for Offending IPS Follows #" >> $LOGDIR/whois-v-mode.txt
      echo "##########################################" >> $LOGDIR/whois-v-mode.txt
      echo "# Scan time: " $dt>> $DIR/whois-v-mode.txt
      echo "------------------------------------------">>$LOGDIR/whois-v-mode.txt
      echo "" >> $LOGDIR/whois-v-mode.txt
      for i in `cat $DIR/offending-ips.log|grep -v "#"`
      do
      if [ ! $i = $THISIP ]
      then	
        ADDR=$i
        echo "#  WHOIS FOR $ADDR:  " >>$LOGDIR/whois-v-mode.txt
        echo "##########################################" >> $LOGDIR/whois-v-mode.txt
	whois $ADDR >> $LOGDIR/whois-v-mode.txt
        echo "${DG} ---> 🦉 Whois for $ADDR done. Saved to $LOGDIR/whois-v-mode.txt "
      fi  
      done
      for i in `cat $DIR/offending-ips.log|grep -v "#"`
      do
      if [ ! $i = $THISIP ]
      then	
	ADDR=$i
	/sbin/iptables -t filter -I INPUT -s $ADDR -j DROP
	/sbin/iptables -t filter -I OUTPUT -s $ADDR -j DROP
	/sbin/iptables -t filter -I FORWARD -s $ADDR -j DROP
	/sbin/iptables -t filter -I INPUT -d $ADDR -j REJECT
	/sbin/iptables -t filter -I OUTPUT -d $ADDR -j REJECT
	/sbin/iptables -t filter -I FORWARD -d $ADDR -j REJECT
	echo $ADDR >> $LOGDIR/blocked-ips.log
	cat $LOGDIR/blocked-ips.log | sort | uniq >> blocked-ips.log
	mv blocked-ips.log $LOGDIR/blocked-ips.log
	echo " ---> 🚫 Blocked all connections from $ADDR "
      fi
      done
#      sleep 1	
#      rm $DIR/$PORT.log	
      echo
    fi
    sleep 2
    done
      if [ -f $DIR/offending-ips.log ]	
        then
          rm $DIR/offending-ips.log
      fi
      if [ -f $DIR/v-mode.log ]
        then    
          rm $DIR/v-mode.log
      fi
}

#########################
# MONITORING ONLY
#########################
nologs()
{
  echo "${BLUE}-----------------------------------------------------"
  echo "${BLUE}         👀    No Logs / Monitor Only    👀          "
  echo "${BLUE}-----------------------------------------------------"
  echo ${LIGHT_MAGENTA}
  if [ -z "${PORT}" ];
    then	
      read -p 'Set Port # to monitor ' PORT
  fi 
  echo -e "${GREEN}---> KPot Started on port $PORT $(date)."
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
  if [ -f pots/s-mode.log ]
    then
      echo "${BLUE}-----------------------------------------------------"
      echo "${BLUE}        📀    Parsing and Sorting Logs    📀         "
      echo "${BLUE}-----------------------------------------------------"
      cat <$DIR/s-mode.log | base64 -d > converted.log
      cat converted.log | grep -oa '[1-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq > offender-ips.log
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
		echo "🚫${GREEN} Blocked all connections from ${RED} $ADDR ${DG}"
	      done
	      echo -ne 'Cleaning up.\n'
	      sleep 1		
	      rm $DIR/offending-ips.log
	      echo -ne 'Cleaning up..\n'
              mkdir -p $DIR/archive	
	      echo -ne 'Cleaning up...\n'
	      echo "${YELLOW}--->Archiving Logs ....."
	      sleep 1
	      if [ -f pots/s-mode.log ] || [ -f pots/v-mode.log ]
	        then
	          tar -cvzf kpots_logs_$now.tar.gz pots/*.log
	          echo -ne 'Cleaning up.....\n'
                  mv kpots_logs_$now.tar.gz $DIR/archive/kpots_logs_$dt.tar.gz
 	          echo -ne 'Cleaning up......\n'
                  rm $DIR/*.log
	          echo
	          echo "${GREEN}--->Finished cleanup. Old logs saved to $DIR/archive/kpots_logs_$dt.tar.gz"
	        else
	          echo -e ${RED}'---> Nothing to do'     
	      fi
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

whoareyou()
{
#echo $THISIP
#sleep 15
  if [ -f pots/offending-ips.log ]
    then
      echo "##########################################" > $DIR/whois-$now.txt
      echo "# 🦉WHOIS Info for Offending IPS Follows #" >> $DIR/whois-$now.txt
      echo "##########################################" >> $DIR/whois-$now.txt
      echo "# Scan time: " $dt>> $DIR/whois-$now.txt
      echo "------------------------------------------">>$DIR/whois-$now.txt
      echo "" >> $DIR/whois-$now.txt
      echo "${BLUE}-----------------------------------------------------"
      echo "${BLUE}        🦉      Offending IPs Whois      🦉          "
      echo "${BLUE}-----------------------------------------------------"
      for i in `cat $DIR/offending-ips.log|grep -v "#"`
      do
        ADDR=$i
        echo "#  WHOIS FOR $ADDR:  " >>$DIR/whois-$now.txt
        echo "##########################################" >> $DIR/whois-$now.txt
	whois $ADDR >> $DIR/whois-$now.txt
        echo "${GREEN} ---> 🦉 Whois for $ADDR done. Saved to $DIR/whois-$now.txt "
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
       H) whoareyou       
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
#if [ -f pots/offending-ips.log ]
#  then
#    rm $DIR/offending-ips.log
#fi
#quit()
#{
echo " "
echo "${LIGHT_MAGENTA}          👋   Goodbye, and Thanks for using Kpots   👋"
echo -ne '👽\r'
sleep .1
echo -ne '👽👽\r'
sleep .1
echo -ne '👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .1
echo -ne '👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽👽\r'
sleep .5
clear
printf "
		\e[49m                  \e[38;5;95;49m▄▄\e[38;5;52;49m▄\e[38;5;234;48;5;95m▄\e[38;5;237;49m▄\e[38;5;239;49m▄\e[38;5;237;49m▄▄\e[49m                 \e[m
		\e[49m                 \e[38;5;131;48;5;131m▄\e[38;5;131;48;5;1m▄\e[38;5;131;48;5;94m▄\e[38;5;94;48;5;94m▄\e[38;5;234;48;5;236m▄\e[38;5;52;48;5;52m▄\e[38;5;235;48;5;234m▄\e[38;5;234;48;5;236m▄\e[38;5;236;48;5;236m▄\e[38;5;235;48;5;239m▄\e[38;5;239;49m▄▄\e[49m              \e[m
		\e[49m              \e[38;5;131;49m▄\e[38;5;95;49m▄\e[38;5;130;48;5;131m▄\e[38;5;94;48;5;95m▄\e[38;5;94;48;5;94m▄▄\e[38;5;130;48;5;94m▄\e[38;5;94;48;5;52m▄▄\e[38;5;94;48;5;94m▄\e[38;5;233;48;5;234m▄\e[38;5;234;48;5;235m▄\e[38;5;235;48;5;234m▄\e[38;5;234;48;5;237m▄\e[38;5;235;48;5;236m▄\e[49m              \e[m
		\e[49m             \e[38;5;94;49m▄\e[38;5;94;48;5;94m▄\e[38;5;1;48;5;94m▄\e[38;5;130;48;5;94m▄\e[38;5;236;48;5;94m▄\e[38;5;167;48;5;131m▄\e[38;5;130;48;5;94m▄\e[38;5;130;48;5;167m▄\e[38;5;166;48;5;94m▄\e[38;5;94;48;5;52m▄\e[38;5;131;48;5;94m▄\e[38;5;233;48;5;234m▄\e[38;5;234;48;5;234m▄▄\e[38;5;233;48;5;233m▄▄\e[38;5;234;48;5;236m▄\e[38;5;236;49m▄\e[38;5;233;49m▄\e[49m           \e[m
		\e[49m          \e[38;5;131;49m▄▄\e[38;5;130;48;5;1m▄\e[38;5;94;48;5;1m▄\e[38;5;255;48;5;94m▄\e[38;5;254;48;5;130m▄\e[38;5;255;48;5;181m▄\e[38;5;223;48;5;94m▄\e[38;5;173;48;5;1m▄\e[38;5;166;48;5;130m▄▄\e[38;5;166;48;5;166m▄\e[38;5;130;48;5;94m▄\e[38;5;234;48;5;234m▄\e[38;5;52;48;5;234m▄\e[38;5;238;48;5;233m▄\e[38;5;243;48;5;237m▄\e[38;5;103;48;5;60m▄\e[38;5;110;48;5;232m▄\e[38;5;110;48;5;233m▄\e[38;5;233;48;5;233m▄\e[38;5;234;48;5;234m▄\e[38;5;239;49m▄\e[49m          \e[m
		\e[49m      \e[38;5;131;49m▄\e[38;5;130;48;5;95m▄\e[38;5;94;48;5;130m▄\e[38;5;130;48;5;130m▄\e[38;5;1;48;5;130m▄\e[38;5;255;48;5;1m▄\e[38;5;255;48;5;131m▄\e[38;5;15;48;5;15m▄\e[38;5;255;48;5;15m▄\e[38;5;255;48;5;255m▄\e[38;5;187;48;5;230m▄\e[38;5;187;48;5;224m▄\e[38;5;230;48;5;223m▄\e[38;5;223;48;5;179m▄\e[38;5;180;48;5;166m▄\e[38;5;173;48;5;166m▄\e[38;5;130;48;5;94m▄\e[38;5;180;48;5;52m▄\e[38;5;187;48;5;95m▄\e[38;5;251;48;5;138m▄\e[38;5;249;48;5;145m▄\e[38;5;249;48;5;248m▄\e[38;5;247;48;5;109m▄\e[38;5;145;48;5;110m▄\e[38;5;248;48;5;147m▄\e[38;5;110;48;5;233m▄\e[38;5;233;48;5;236m▄\e[38;5;233;49m▄\e[38;5;235;49m▄\e[38;5;234;49m▄\e[38;5;95;49m▄\e[49m      \e[m
		\e[49m  \e[49;38;5;95m▀\e[38;5;94;48;5;95m▄\e[38;5;1;48;5;131m▄\e[38;5;130;48;5;95m▄\e[38;5;94;48;5;94m▄\e[38;5;130;48;5;130m▄▄\e[38;5;130;48;5;1m▄\e[38;5;224;48;5;253m▄\e[38;5;255;48;5;255m▄\e[38;5;230;48;5;255m▄▄\e[38;5;255;48;5;255m▄\e[38;5;230;48;5;255m▄\e[38;5;230;48;5;230m▄▄\e[38;5;230;48;5;187m▄\e[38;5;230;48;5;254m▄\e[38;5;230;48;5;7m▄\e[38;5;181;48;5;230m▄\e[38;5;254;48;5;187m▄\e[38;5;253;48;5;254m▄\e[38;5;251;48;5;253m▄\e[38;5;251;48;5;252m▄\e[38;5;7;48;5;250m▄\e[38;5;249;48;5;249m▄\e[38;5;145;48;5;249m▄\e[38;5;247;48;5;145m▄\e[38;5;247;48;5;243m▄\e[38;5;8;48;5;8m▄\e[38;5;102;48;5;103m▄\e[38;5;8;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;235;48;5;234m▄\e[38;5;233;48;5;235m▄\e[38;5;236;48;5;238m▄\e[38;5;236;48;5;101m▄\e[38;5;8;49m▄\e[38;5;101;49m▄\e[49m  \e[m
		\e[38;5;95;49m▄\e[38;5;238;48;5;95m▄\e[38;5;94;48;5;95m▄\e[38;5;52;48;5;1m▄\e[38;5;94;48;5;52m▄\e[38;5;130;48;5;52m▄\e[38;5;94;48;5;166m▄\e[38;5;130;48;5;130m▄\e[38;5;130;48;5;166m▄\e[38;5;187;48;5;179m▄\e[38;5;224;48;5;230m▄\e[38;5;224;48;5;254m▄\e[38;5;253;48;5;230m▄\e[38;5;230;48;5;230m▄▄\e[38;5;254;48;5;230m▄▄▄\e[38;5;230;48;5;230m▄▄\e[38;5;255;48;5;254m▄\e[38;5;187;48;5;254m▄▄\e[38;5;253;48;5;144m▄\e[38;5;187;48;5;254m▄\e[38;5;251;48;5;251m▄\e[38;5;7;48;5;7m▄\e[38;5;249;48;5;249m▄\e[38;5;247;48;5;248m▄\e[38;5;248;48;5;248m▄\e[38;5;145;48;5;248m▄\e[38;5;245;48;5;247m▄\e[38;5;102;48;5;245m▄\e[38;5;102;48;5;109m▄\e[38;5;237;48;5;233m▄\e[38;5;238;48;5;233m▄\e[38;5;235;48;5;234m▄\e[38;5;238;48;5;236m▄\e[38;5;237;48;5;236m▄▄\e[38;5;236;48;5;239m▄\e[38;5;240;48;5;95m▄\e[38;5;239;49m▄\e[m
		\e[38;5;94;48;5;130m▄\e[38;5;234;48;5;234m▄\e[38;5;52;48;5;52m▄\e[38;5;52;48;5;1m▄\e[38;5;94;48;5;1m▄\e[38;5;94;48;5;94m▄▄▄\e[38;5;130;48;5;166m▄\e[38;5;173;48;5;186m▄\e[38;5;223;48;5;223m▄\e[38;5;187;48;5;224m▄\e[38;5;224;48;5;230m▄▄\e[38;5;230;48;5;224m▄\e[38;5;230;48;5;230m▄\e[38;5;187;48;5;230m▄\e[38;5;230;48;5;230m▄\e[38;5;230;48;5;254m▄▄\e[38;5;187;48;5;187m▄\e[38;5;254;48;5;181m▄\e[38;5;254;48;5;253m▄\e[38;5;254;48;5;187m▄\e[38;5;187;48;5;250m▄\e[38;5;251;48;5;251m▄\e[38;5;250;48;5;250m▄\e[38;5;144;48;5;250m▄\e[38;5;145;48;5;145m▄\e[38;5;145;48;5;248m▄\e[38;5;247;48;5;249m▄\e[38;5;8;48;5;246m▄\e[38;5;246;48;5;102m▄\e[38;5;243;48;5;243m▄\e[38;5;52;48;5;235m▄\e[38;5;233;48;5;233m▄▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;233;48;5;234m▄\e[38;5;235;48;5;234m▄\e[38;5;234;48;5;234m▄\e[38;5;235;48;5;236m▄\e[m
		\e[49;38;5;95m▀\e[38;5;52;48;5;236m▄\e[38;5;1;48;5;52m▄\e[38;5;95;48;5;52m▄\e[38;5;94;48;5;94m▄\e[38;5;130;48;5;52m▄\e[38;5;167;48;5;130m▄\e[38;5;130;48;5;173m▄\e[38;5;166;48;5;166m▄\e[38;5;202;48;5;94m▄\e[38;5;180;48;5;180m▄\e[38;5;181;48;5;187m▄\e[38;5;187;48;5;254m▄\e[38;5;230;48;5;254m▄\e[38;5;187;48;5;187m▄\e[38;5;230;48;5;187m▄\e[38;5;230;48;5;230m▄\e[38;5;255;48;5;230m▄\e[38;5;230;48;5;230m▄▄\e[38;5;254;48;5;230m▄\e[38;5;254;48;5;254m▄▄\e[38;5;249;48;5;187m▄\e[38;5;251;48;5;187m▄\e[38;5;251;48;5;252m▄\e[38;5;249;48;5;250m▄\e[38;5;144;48;5;250m▄\e[38;5;145;48;5;144m▄\e[38;5;249;48;5;247m▄\e[38;5;247;48;5;246m▄\e[38;5;245;48;5;102m▄\e[38;5;245;48;5;245m▄\e[38;5;95;48;5;101m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;233m▄▄▄▄\e[38;5;234;48;5;233m▄\e[38;5;233;48;5;234m▄\e[38;5;237;48;5;236m▄\e[49m \e[m
		\e[49m \e[38;5;237;48;5;234m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;52m▄\e[38;5;233;48;5;94m▄\e[38;5;233;48;5;52m▄\e[38;5;233;48;5;1m▄\e[38;5;233;48;5;130m▄\e[38;5;234;48;5;130m▄\e[38;5;130;48;5;94m▄\e[38;5;144;48;5;137m▄\e[38;5;187;48;5;180m▄\e[38;5;180;48;5;187m▄\e[38;5;187;48;5;254m▄\e[38;5;254;48;5;254m▄\e[38;5;187;48;5;187m▄\e[38;5;187;48;5;254m▄\e[38;5;254;48;5;187m▄▄\e[38;5;253;48;5;7m▄\e[38;5;187;48;5;187m▄\e[38;5;187;48;5;254m▄\e[38;5;187;48;5;187m▄▄\e[38;5;7;48;5;251m▄▄\e[38;5;251;48;5;246m▄\e[38;5;187;48;5;249m▄\e[38;5;7;48;5;248m▄\e[38;5;249;48;5;145m▄\e[38;5;246;48;5;246m▄\e[38;5;245;48;5;246m▄\e[38;5;8;48;5;102m▄\e[38;5;52;48;5;236m▄\e[38;5;52;48;5;234m▄\e[38;5;233;48;5;233m▄▄▄▄▄▄\e[38;5;235;48;5;235m▄\e[49m \e[m
		\e[49m \e[38;5;235;48;5;234m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;233;48;5;234m▄\e[38;5;52;48;5;52m▄\e[38;5;52;48;5;233m▄\e[38;5;1;48;5;52m▄\e[38;5;88;48;5;1m▄\e[38;5;144;48;5;180m▄\e[38;5;180;48;5;144m▄\e[38;5;180;48;5;181m▄\e[38;5;187;48;5;187m▄\e[38;5;230;48;5;254m▄\e[38;5;230;48;5;230m▄\e[38;5;254;48;5;254m▄\e[38;5;187;48;5;187m▄▄▄▄▄▄▄\e[38;5;187;48;5;251m▄\e[38;5;187;48;5;7m▄\e[38;5;249;48;5;249m▄\e[38;5;252;48;5;145m▄\e[38;5;251;48;5;251m▄\e[38;5;145;48;5;144m▄\e[38;5;245;48;5;246m▄\e[38;5;246;48;5;241m▄\e[38;5;101;48;5;95m▄\e[38;5;234;48;5;233m▄\e[38;5;233;48;5;233m▄▄▄▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄▄▄\e[49m \e[m
		\e[49m  \e[38;5;233;48;5;233m▄▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;233;48;5;52m▄\e[38;5;234;48;5;52m▄\e[38;5;234;48;5;233m▄\e[38;5;235;48;5;52m▄\e[38;5;144;48;5;180m▄\e[38;5;138;48;5;144m▄\e[38;5;181;48;5;144m▄\e[38;5;187;48;5;187m▄\e[38;5;230;48;5;230m▄\e[38;5;15;48;5;230m▄\e[38;5;131;48;5;230m▄\e[38;5;223;48;5;230m▄\e[38;5;187;48;5;187m▄▄\e[38;5;187;48;5;249m▄\e[38;5;187;48;5;254m▄\e[38;5;251;48;5;255m▄\e[38;5;187;48;5;250m▄\e[38;5;187;48;5;187m▄\e[38;5;180;48;5;254m▄\e[38;5;253;48;5;187m▄\e[38;5;187;48;5;187m▄\e[38;5;7;48;5;7m▄\e[38;5;247;48;5;247m▄\e[38;5;245;48;5;246m▄\e[38;5;246;48;5;243m▄\e[38;5;94;48;5;101m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;233m▄▄▄▄▄▄▄\e[49m  \e[m
		\e[49m  \e[38;5;235;48;5;234m▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;52;48;5;233m▄\e[38;5;233;48;5;233m▄▄\e[38;5;180;48;5;233m▄\e[38;5;180;48;5;234m▄\e[38;5;138;48;5;137m▄\e[38;5;144;48;5;144m▄\e[38;5;180;48;5;144m▄\e[38;5;144;48;5;187m▄\e[38;5;144;48;5;223m▄\e[38;5;230;48;5;254m▄\e[38;5;52;48;5;94m▄\e[38;5;254;48;5;254m▄\e[38;5;254;48;5;187m▄\e[38;5;187;48;5;187m▄▄▄▄\e[38;5;254;48;5;254m▄\e[38;5;187;48;5;254m▄\e[38;5;235;48;5;131m▄\e[38;5;246;48;5;253m▄\e[38;5;250;48;5;144m▄\e[38;5;144;48;5;7m▄\e[38;5;246;48;5;101m▄\e[38;5;245;48;5;246m▄\e[38;5;101;48;5;101m▄\e[38;5;240;48;5;101m▄\e[38;5;234;48;5;233m▄\e[38;5;95;48;5;233m▄\e[38;5;233;48;5;233m▄\e[48;5;233m \e[38;5;233;48;5;233m▄▄\e[49;38;5;233m▀\e[49m   \e[m
		\e[49m   \e[49;38;5;234m▀\e[38;5;234;48;5;233m▄\e[38;5;233;48;5;233m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;235m▄\e[38;5;237;48;5;144m▄\e[38;5;101;48;5;144m▄\e[38;5;144;48;5;144m▄▄\e[38;5;101;48;5;101m▄\e[38;5;236;48;5;95m▄\e[38;5;232;48;5;101m▄\e[38;5;232;48;5;233m▄\e[38;5;237;48;5;138m▄\e[38;5;144;48;5;181m▄\e[38;5;138;48;5;7m▄\e[38;5;249;48;5;187m▄\e[38;5;144;48;5;187m▄\e[38;5;101;48;5;181m▄\e[38;5;144;48;5;7m▄\e[38;5;101;48;5;144m▄\e[38;5;233;48;5;233m▄\e[38;5;234;48;5;144m▄\e[38;5;239;48;5;245m▄\e[38;5;95;48;5;138m▄\e[38;5;101;48;5;245m▄\e[38;5;246;48;5;246m▄\e[38;5;101;48;5;8m▄\e[38;5;144;48;5;138m▄\e[38;5;95;48;5;138m▄\e[38;5;95;48;5;235m▄\e[38;5;235;48;5;233m▄\e[38;5;233;48;5;233m▄▄▄\e[49m    \e[m
		\e[49m     \e[38;5;237;48;5;234m▄\e[38;5;233;48;5;233m▄▄\e[38;5;233;48;5;232m▄\e[38;5;137;48;5;236m▄\e[38;5;187;48;5;238m▄\e[38;5;144;48;5;144m▄\e[38;5;187;48;5;144m▄\e[38;5;180;48;5;238m▄\e[38;5;59;48;5;232m▄\e[38;5;237;48;5;180m▄\e[38;5;237;48;5;232m▄\e[38;5;94;48;5;237m▄\e[38;5;233;48;5;232m▄\e[38;5;0;48;5;237m▄\e[38;5;187;48;5;144m▄\e[38;5;255;48;5;144m▄\e[38;5;249;48;5;144m▄\e[38;5;233;48;5;232m▄\e[38;5;52;48;5;233m▄\e[38;5;101;48;5;94m▄\e[38;5;95;48;5;166m▄\e[38;5;233;48;5;233m▄\e[38;5;237;48;5;235m▄\e[38;5;101;48;5;242m▄\e[38;5;247;48;5;245m▄\e[38;5;243;48;5;102m▄\e[38;5;95;48;5;234m▄\e[38;5;101;48;5;101m▄\e[38;5;233;48;5;233m▄\e[38;5;233;48;5;232m▄\e[38;5;233;48;5;233m▄\e[49;38;5;233m▀\e[49m     \e[m
		\e[49m       \e[49;38;5;233m▀▀\e[38;5;144;48;5;187m▄\e[38;5;180;48;5;137m▄\e[38;5;144;48;5;144m▄\e[38;5;187;48;5;7m▄\e[38;5;187;48;5;223m▄▄\e[38;5;181;48;5;234m▄\e[38;5;1;48;5;233m▄\e[38;5;187;48;5;236m▄\e[38;5;254;48;5;137m▄\e[38;5;187;48;5;187m▄\e[38;5;230;48;5;224m▄\e[38;5;254;48;5;254m▄\e[38;5;144;48;5;144m▄\e[38;5;249;48;5;144m▄\e[38;5;7;48;5;232m▄\e[38;5;250;48;5;233m▄\e[38;5;235;48;5;233m▄\e[38;5;249;48;5;239m▄\e[38;5;249;48;5;138m▄\e[38;5;144;48;5;144m▄\e[38;5;246;48;5;245m▄\e[38;5;242;48;5;241m▄\e[38;5;242;48;5;101m▄\e[38;5;246;48;5;101m▄\e[38;5;52;48;5;233m▄\e[49;38;5;233m▀\e[49m       \e[m
		\e[49m          \e[49;38;5;144m▀\e[38;5;138;48;5;144m▄\e[38;5;144;48;5;187m▄\e[38;5;0;48;5;187m▄\e[38;5;233;48;5;52m▄\e[38;5;187;48;5;234m▄\e[38;5;187;48;5;187m▄\e[38;5;144;48;5;254m▄\e[38;5;234;48;5;224m▄\e[38;5;234;48;5;181m▄\e[38;5;233;48;5;52m▄▄\e[38;5;233;48;5;249m▄\e[38;5;233;48;5;250m▄\e[38;5;101;48;5;7m▄\e[38;5;251;48;5;187m▄\e[38;5;187;48;5;52m▄\e[38;5;233;48;5;52m▄\e[38;5;138;48;5;249m▄\e[38;5;144;48;5;144m▄\e[38;5;243;48;5;102m▄\e[38;5;95;48;5;95m▄\e[49;38;5;245m▀\e[49m          \e[m
		\e[49m           \e[49;38;5;8m▀\e[38;5;243;48;5;138m▄\e[38;5;233;48;5;233m▄\e[38;5;239;48;5;144m▄\e[38;5;237;48;5;101m▄\e[38;5;144;48;5;237m▄\e[38;5;187;48;5;223m▄\e[38;5;144;48;5;233m▄\e[38;5;245;48;5;232m▄\e[38;5;235;48;5;233m▄\e[38;5;239;48;5;233m▄\e[38;5;144;48;5;232m▄\e[38;5;250;48;5;233m▄\e[38;5;250;48;5;249m▄\e[38;5;249;48;5;59m▄\e[38;5;234;48;5;144m▄\e[38;5;95;48;5;250m▄\e[38;5;233;48;5;233m▄\e[38;5;101;48;5;247m▄\e[49;38;5;59m▀\e[49m            \e[m
		\e[49m            \e[38;5;242;48;5;242m▄\e[38;5;241;48;5;236m▄\e[38;5;101;48;5;233m▄\e[38;5;239;48;5;233m▄\e[38;5;232;48;5;233m▄\e[38;5;232;48;5;144m▄\e[38;5;233;48;5;144m▄\e[38;5;233;48;5;138m▄\e[38;5;232;48;5;138m▄\e[38;5;0;48;5;137m▄\e[38;5;233;48;5;144m▄▄\e[38;5;232;48;5;144m▄\e[38;5;239;48;5;95m▄\e[38;5;101;48;5;233m▄▄\e[38;5;95;48;5;233m▄\e[38;5;239;48;5;241m▄\e[49m             \e[m
		\e[49m             \e[38;5;239;48;5;239m▄\e[38;5;242;48;5;101m▄\e[38;5;144;48;5;144m▄\e[38;5;245;48;5;144m▄\e[38;5;95;48;5;238m▄\e[38;5;52;48;5;234m▄\e[38;5;233;48;5;234m▄\e[38;5;237;48;5;137m▄▄\e[38;5;233;48;5;137m▄\e[38;5;235;48;5;235m▄\e[38;5;246;48;5;233m▄\e[38;5;101;48;5;144m▄\e[38;5;247;48;5;144m▄\e[38;5;59;48;5;101m▄\e[38;5;238;48;5;239m▄\e[49m              \e[m
		\e[49m              \e[49;38;5;238m▀\e[38;5;239;48;5;95m▄\e[38;5;101;48;5;144m▄\e[38;5;144;48;5;102m▄\e[38;5;101;48;5;233m▄\e[38;5;233;48;5;131m▄\e[38;5;233;48;5;88m▄\e[38;5;233;48;5;1m▄\e[38;5;233;48;5;235m▄\e[38;5;245;48;5;232m▄\e[38;5;144;48;5;245m▄\e[38;5;101;48;5;247m▄\e[38;5;238;48;5;241m▄\e[49;38;5;237m▀\e[49m               \e[m
		\e[49m                \e[49;38;5;242m▀\e[38;5;245;48;5;144m▄\e[38;5;144;48;5;138m▄\e[38;5;181;48;5;241m▄\e[38;5;138;48;5;234m▄▄\e[38;5;144;48;5;138m▄\e[38;5;246;48;5;144m▄\e[38;5;240;48;5;246m▄\e[49;38;5;239m▀\e[49m                 \e[m
		\e[49m                  \e[49;38;5;239m▀\e[38;5;236;48;5;101m▄\e[38;5;236;48;5;95m▄\e[38;5;237;48;5;101m▄\e[38;5;236;48;5;101m▄\e[49;38;5;241m▀\e[49m                   \e[m
";
echo
echo "               🎈🎈🎈🎈🎈   yOu'Ll fLoAt tOo!   🎈🎈🎈🎈🎈"
printf "
	\e[49m                                                       \e[m
	\e[49m                                                       \e[m
	\e[49m    \e[38;5;9;49m▄\e[48;5;9m   \e[38;5;9;49m▄▄▄\e[38;5;9;48;5;9m▄\e[48;5;9m  \e[38;5;9;48;5;9m▄\e[38;5;9;49m▄\e[49m                    \e[38;5;9;49m▄▄▄▄▄\e[49m              \e[m
	\e[49m   \e[38;5;9;48;5;9m▄▄\e[38;5;233;48;5;52m▄\e[38;5;235;48;5;52m▄\e[38;5;232;48;5;232m▄\e[38;5;9;48;5;9m▄▄\e[38;5;160;48;5;9m▄\e[38;5;234;48;5;9m▄\e[38;5;235;48;5;52m▄\e[38;5;233;48;5;52m▄\e[38;5;9;48;5;232m▄\e[48;5;9m  \e[38;5;9;49m▄▄▄▄▄▄▄\e[49m   \e[38;5;9;49m▄▄▄▄▄▄▄▄\e[38;5;9;48;5;9m▄▄\e[38;5;233;48;5;9m▄▄\e[38;5;52;48;5;9m▄\e[38;5;9;48;5;9m▄\e[48;5;9m \e[38;5;9;49m▄▄▄▄▄▄▄▄▄\e[49m    \e[m
	\e[49m   \e[48;5;9m  \e[38;5;233;48;5;233m▄\e[48;5;236m \e[38;5;232;48;5;232m▄\e[38;5;160;48;5;9m▄\e[38;5;235;48;5;160m▄\e[38;5;236;48;5;235m▄\e[38;5;233;48;5;236m▄\e[38;5;9;48;5;233m▄\e[38;5;9;48;5;9m▄\e[48;5;9m \e[38;5;9;48;5;9m▄\e[38;5;233;48;5;9m▄▄\e[38;5;232;48;5;9m▄\e[38;5;233;48;5;9m▄\e[38;5;234;48;5;9m▄▄\e[38;5;233;48;5;9m▄\e[38;5;160;48;5;9m▄\e[38;5;9;48;5;9m▄▄▄▄\e[38;5;233;48;5;9m▄\e[38;5;234;48;5;9m▄▄▄\e[38;5;233;48;5;9m▄\e[38;5;9;48;5;9m▄▄▄\e[38;5;233;48;5;9m▄\e[38;5;235;48;5;233m▄\e[38;5;237;48;5;235m▄\e[38;5;234;48;5;52m▄\e[38;5;233;48;5;9m▄▄\e[38;5;9;48;5;9m▄▄\e[38;5;233;48;5;9m▄\e[38;5;234;48;5;9m▄▄▄\e[38;5;233;48;5;9m▄▄\e[38;5;9;48;5;9m▄▄\e[49m   \e[m
	\e[49m   \e[48;5;9m  \e[38;5;233;48;5;233m▄\e[38;5;237;48;5;236m▄\e[38;5;237;48;5;234m▄\e[38;5;236;48;5;235m▄\e[38;5;233;48;5;236m▄\e[38;5;9;48;5;233m▄\e[38;5;9;48;5;9m▄\e[48;5;9m \e[38;5;9;48;5;9m▄\e[48;5;9m  \e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;233;48;5;235m▄\e[38;5;9;48;5;233m▄\e[38;5;9;48;5;232m▄\e[38;5;9;48;5;234m▄\e[38;5;234;48;5;237m▄\e[38;5;235;48;5;234m▄\e[38;5;52;48;5;9m▄\e[38;5;9;48;5;9m▄\e[38;5;232;48;5;9m▄\e[38;5;236;48;5;234m▄\e[38;5;233;48;5;236m▄\e[38;5;9;48;5;233m▄\e[38;5;9;48;5;232m▄\e[38;5;9;48;5;233m▄\e[38;5;234;48;5;236m▄\e[38;5;236;48;5;234m▄\e[38;5;233;48;5;9m▄\e[48;5;9m \e[38;5;9;48;5;233m▄\e[38;5;233;48;5;235m▄\e[38;5;235;48;5;237m▄\e[38;5;52;48;5;234m▄\e[38;5;9;48;5;233m▄▄\e[38;5;9;48;5;9m▄\e[38;5;232;48;5;232m▄\e[38;5;235;48;5;235m▄\e[38;5;232;48;5;234m▄\e[38;5;9;48;5;1m▄▄\e[38;5;9;48;5;232m▄\e[38;5;9;48;5;233m▄\e[48;5;9m  \e[49m   \e[m
	\e[49m   \e[48;5;9m  \e[48;5;233m \e[38;5;236;48;5;236m▄\e[38;5;232;48;5;234m▄\e[38;5;1;48;5;236m▄\e[38;5;236;48;5;237m▄\e[38;5;237;48;5;233m▄\e[38;5;233;48;5;9m▄\e[38;5;9;48;5;9m▄\e[48;5;9m   \e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;233;48;5;233m▄\e[48;5;9m   \e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;232;48;5;232m▄\e[48;5;9m \e[38;5;233;48;5;233m▄\e[48;5;236m \e[48;5;232m \e[48;5;9m   \e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;233;48;5;233m▄\e[48;5;9m  \e[48;5;233m \e[38;5;235;48;5;235m▄\e[48;5;52m \e[48;5;9m  \e[38;5;9;48;5;9m▄▄\e[38;5;9;48;5;234m▄\e[38;5;232;48;5;235m▄\e[38;5;233;48;5;234m▄\e[38;5;233;48;5;233m▄\e[38;5;236;48;5;232m▄\e[38;5;235;48;5;160m▄\e[38;5;160;48;5;9m▄\e[48;5;9m \e[38;5;9;49m▄\e[49m  \e[m
	\e[49m   \e[48;5;9m  \e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;232;48;5;232m▄\e[38;5;9;48;5;9m▄\e[38;5;9;48;5;1m▄\e[38;5;88;48;5;235m▄\e[38;5;235;48;5;237m▄\e[38;5;236;48;5;233m▄\e[38;5;233;48;5;9m▄\e[38;5;9;48;5;9m▄▄\e[38;5;233;48;5;233m▄\e[38;5;236;48;5;236m▄\e[38;5;234;48;5;234m▄\e[38;5;233;48;5;9m▄▄\e[38;5;234;48;5;9m▄\e[38;5;236;48;5;234m▄\e[38;5;234;48;5;235m▄\e[38;5;9;48;5;1m▄\e[38;5;9;48;5;9m▄\e[38;5;9;48;5;233m▄\e[38;5;234;48;5;236m▄\e[38;5;236;48;5;234m▄\e[38;5;234;48;5;9m▄\e[38;5;233;48;5;9m▄\e[38;5;234;48;5;9m▄\e[38;5;236;48;5;234m▄\e[38;5;234;48;5;236m▄\e[38;5;9;48;5;233m▄\e[48;5;9m \e[38;5;9;48;5;9m▄\e[38;5;233;48;5;233m▄\e[38;5;236;48;5;235m▄\e[38;5;235;48;5;52m▄\e[38;5;233;48;5;9m▄▄\e[38;5;9;48;5;9m▄\e[38;5;232;48;5;9m▄\e[38;5;233;48;5;9m▄\e[38;5;232;48;5;9m▄▄▄\e[38;5;235;48;5;233m▄\e[38;5;235;48;5;235m▄\e[38;5;124;48;5;52m▄\e[48;5;9m \e[38;5;9;48;5;9m▄\e[49m  \e[m
	\e[49m   \e[38;5;9;48;5;9m▄▄\e[38;5;9;48;5;233m▄▄\e[38;5;9;48;5;232m▄\e[38;5;9;48;5;9m▄\e[48;5;9m \e[38;5;9;48;5;9m▄\e[38;5;9;48;5;124m▄\e[38;5;9;48;5;233m▄▄▄\e[38;5;9;48;5;9m▄\e[38;5;233;48;5;233m▄\e[38;5;235;48;5;236m▄\e[48;5;232m \e[38;5;9;48;5;52m▄\e[38;5;9;48;5;233m▄▄▄\e[38;5;9;48;5;9m▄▄\e[48;5;9m \e[38;5;9;48;5;9m▄▄\e[38;5;9;48;5;233m▄▄▄▄▄\e[38;5;9;48;5;9m▄▄\e[48;5;9m \e[38;5;9;48;5;9m▄▄\e[38;5;9;48;5;233m▄▄▄▄\e[38;5;9;48;5;9m▄\e[38;5;9;48;5;52m▄\e[38;5;9;48;5;233m▄▄▄▄▄\e[38;5;9;48;5;52m▄\e[38;5;9;48;5;9m▄\e[48;5;9m \e[49m   \e[m
	\e[49m    \e[49;38;5;9m▀▀▀▀▀\e[49m  \e[49;38;5;9m▀▀▀\e[48;5;9m  \e[38;5;233;48;5;233m▄\e[38;5;233;48;5;236m▄\e[48;5;232m \e[38;5;9;48;5;9m▄▄\e[49;38;5;9m▀▀▀\e[49m   \e[49;38;5;9m▀▀▀▀▀▀▀\e[49m   \e[49;38;5;9m▀▀▀▀▀▀▀▀▀▀▀▀▀\e[49m     \e[m
	\e[49m              \e[49;38;5;9m▀\e[48;5;9m  \e[38;5;9;48;5;9m▄▄\e[48;5;9m \e[49;38;5;9m▀\e[49m                                  \e[m
	\e[49m                                                       \e[m
";
tput sgr0
      if [ -f $DIR/offending-ips.log ]	
        then
          rm $DIR/offending-ips.log
      fi
      if [ -f $DIR/v-mode.log ]
        then    
          rm $DIR/v-mode.log
      fi

sleep 5
exit 
#}
