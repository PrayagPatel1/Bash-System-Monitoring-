#!/bin/bash 

echo "=== System Health Dashboard ==="

echo 

# List of commands the program is going to read
echo "Here is a list of commands you can input: 
[1] show-all
[2] show-cpu
[3] show-mem
[4] show-net
[5] quit
"

# Constant Variables
HOSTNAME=$(hostname)
USER=$(whoami)

# CPU Information Variables
CPU_NAME=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
PREV_IDLE=""
PREV_TOTAL=""

user_input=""



while [ "$user_input" != "quit" ]; do 
    read -p ">> " user_input

    if [ "$user_input" == "show-all" ]; then
        echo 

        echo "General System Information" 
        echo "-------------------------------------------------"
        printf "%-20s %10s %10s\n" "Hostname" "User" "OS"
        echo "-------------------------------------------------"
        printf "%-20s %10s %10s\n" "$HOSTNAME" "$USER" "$OSTYPE"
        echo "-------------------------------------------------"

        echo 

        echo "CPU Information" 
        echo "---------------------------------------------------------------------------"
        printf "%-20s %10s %10s %10s %10s\n" "CPU Name" "Cores" "Usage%" "Top Proc" "Temp"
        echo "---------------------------------------------------------------------------"

        echo

        echo "Disk Information"
        echo "-----------------------------------------------------------------------"
        printf "%-20s %10s %10s %10s %10s\n" "Device" "Mounted" "Used" "Free" "Usage%" 
        echo "-----------------------------------------------------------------------"

        echo 

        df -h | grep "^/dev" | awk '{printf "%-20s %10s %10s %10s %10s\n", $1, $6, $3, $4, $5}'

        echo "-----------------------------------------------------------------------"
    fi 
done 