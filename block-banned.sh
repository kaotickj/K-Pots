#!/bin/bash

# Path to the file containing the list of IP addresses
IP_FILE="./logs/blocked-ips.log"

# Define color variables
C=$(printf '\033')
RED="${C}[1;31m"
YELLOW="${C}[1;33m"
NC="${C}[0m"

# IP address to exclude from banning
EXCLUDED_IP="68.59.206.241"

# Function to check if the script is run as root
check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED} 💀 This script must be run as root. Please use sudo. 💀 ${NC}"
    exit 1
  fi
}

# Check if the script is run as root
check_root

# Check if the IP file exists
if [[ ! -f "$IP_FILE" ]]; then
  echo "Error: File '$IP_FILE' not found."
  exit 1
fi

# Iterate through each line in the IP file
while IFS= read -r ip; do
  # Trim any leading or trailing whitespace
  ip=$(echo "$ip" | xargs)
  
  # Skip empty lines or the excluded IP address
  if [[ -z "$ip" || "$ip" == "$EXCLUDED_IP" ]]; then
    continue
  fi
  
  # Block the IP address using iptables
  iptables -A INPUT -s "$ip" -j DROP
  
  # Check if the iptables command was successful
  if [[ $? -eq 0 ]]; then
    echo -e "${RED}🚫 Blocked IP:${NC}${YELLOW} $ip${NC}"
  else
    echo -e "${RED}💀 Failed to block IP: $ip${NC}"
  fi
done < "$IP_FILE"

