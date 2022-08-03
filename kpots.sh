#! /bin/bash
DIR=$(pwd)
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
#  INITIALIZE NEW PORT
###########################
initport()
{
#  PORT=$1 
  clear
  figlet "Port $PORT" > $DIR/$PORT.txt
  figlet "Powered by:" >> $DIR/$PORT.txt
  figlet '  KPots  ' >> $DIR/$PORT.txt
  echo "" >> $DIR/$PORT.txt
  echo "            🕵🔎 Courtesy of KaotickJ 👽" >> $DIR/$PORT.txt 
  echo "" >> $DIR/$PORT.txt
  echo "${GREEN}Finished ...."
  cat $DIR/$PORT.txt
  sleep 2
}


####################
#  SIMPLE
####################
simple()
{
#  PORT=$1
  echo -ne ${YELLOW}'Monitoring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MOnitoring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MoNitoring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonItoring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MoniToring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitOring Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitoRing Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorIng Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitoriNg Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorinG Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorinG Port ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorinG POrt ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorinG PoRt ' $PORT'\r'
  sleep .2
  echo -ne ${YELLOW}'MonitorinG PorT ' $PORT'\r'
  sleep .2
  echo -ne ${DG}'---> Monitoring Port ' $PORT'\n'
  echo ${DG}'---> Logs saving to ' $DIR/$PORT.log''
  echo '---> (hit ctrl c twice to end)'
  sleep .2

  while :
    do
      echo "" >>$DIR/$PORT.log;
      sudo nc -lvnp $PORT < $DIR/$PORT.txt 1>>$DIR/$PORT.log 2>>$DIR/$PORT.log;
      echo $(date) >> $DIR/$PORT.log;
      sleep 2
    done
}
####################
#  VERBOSE
####################
verbose()
{
#  PORT=$1 
#  clear
  mkdir -p $DIR/$PORT/
  touch $DIR/$PORT/long.log
  echo -e "${YELLOW}Logging to ${DG}$DIR/$PORT/long.log"
  echo -e "${GREEN}---> HoneyPot Started on port $PORT $(date)."
  echo -e "${GREEN}HoneyPot Started on port $PORT $(date)." >>$DIR/$PORT/long.log 
  while :
    do
      echo "" >$DIR/$PORT.log;
      sudo nc -lvnp $PORT < $DIR/$PORT.txt 1>>$DIR/$PORT.log 2>>$DIR/$PORT.log;
      echo $(date) >> $DIR/$PORT.log;
      cat $DIR/$PORT.log >>$DIR/$PORT/long.log
      echo
      echo "${RED}Hit from:${DG}"
      cat $DIR/$PORT.log
      sleep 2
    done
}

#########################
#  DELETE
#########################
delete()
{
  rm -R $DIR/$PORT
  rm $DIR/$PORT.log
  sleep 1
  echo "${DG}--->$DIR/$PORT/*.* deleted"
}
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
   echo " ${LIGHT_MAGENTA}Syntax: kpots.sh [-h|-d|-i|-s|-v] ${YELLOW}<PORT>"
   echo ${GREEN}
   echo " options:"
   echo " -------------------------------------------"
   echo " ${YELLOW}-h ${BLUE}Shows this help message"
   echo " ${YELLOW}-d ${YELLOW}<PORT>${BLUE} Deletes logs for specified port."
   echo " ${YELLOW}-i ${YELLOW}<PORT>${BLUE} Generates a new banner for port specified ."
   echo " ${YELLOW}-S ${YELLOW}<PORT>${BLUE} To monitor specified port in simple mode"
   echo " ${YELLOW}-v ${YELLOW}<PORT>${BLUE} To monitor specified port in verbose mode"
   echo 
#   sleep 3	
}


################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

[[ `id -u` -eq 0 ]] || { echo -e "${RED}💀 Must run as root (sudo ./ksploit.sh) 💀"; exit 1; }
#resize -s 30 60
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
   echo " ${LIGHT_MAGENTA}Syntax: kpots.sh [-h|-d|-i|-s|-v] ${YELLOW}<PORT>"
   echo ${GREEN}
   echo " options:"
   echo " -------------------------------------------"
   echo " ${YELLOW}-h ${BLUE}Show this help message"
   echo " ${YELLOW}-d ${YELLOW}<PORT>${BLUE} Deletes logs for specified port."
   echo " ${YELLOW}-i ${YELLOW}<PORT>${BLUE} Generates a new banner for port specified ."
   echo " ${YELLOW}-S ${YELLOW}<PORT>${BLUE} To monitor specified port in simple mode"
   echo " ${YELLOW}-v ${YELLOW}<PORT>${BLUE} To monitor specified port in verbose mode"
   echo 
   echo 

while getopts ":h?:d?:i?:s?:v?" opt; 
do
  case "$opt" in
       h) Help
         exit;;
       d) delete
         ;;  
       i) initport
         ;;
       s) simple
         ;;
       v) verbose
         ;;
       *) 
         echo ${RED}
         echo "💀 invalid option ./kpots.sh -h for help 💀"
         exit;;
    esac
done
tput sgr0 
