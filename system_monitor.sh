#!/bin/bash 

echo "=== System Health Dashboard ==="

echo 


# Constant Variables
HOSTNAME=$(hostname)
USER=$(whoami)

# CPU Information Variables
CPU_NAME=$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
PREV_IDLE=""
PREV_TOTAL=""

# Network Information Varibales


user_input=""



while [ "$user_input" != "quit" ]; do 
    read -p ">> " user_input

    if [ "$user_input" == "run" ]; then
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

        echo 

        echo "Network Infromation"
        ESTABLISHED=$(ss -t | grep ESTAB | wc -l)
        LISTENING=$(ss -tln | grep LISTEN | wc -l)
        echo "-------------------------------------------------------------------------------------"
        printf "%-10s %10s %20s %20s\n" "RX (MB)" "TX (MB)" "Active Connection" "Listening Services"
        echo "-------------------------------------------------------------------------------------"
        cat /proc/net/dev | grep eth0 | awk '{printf "%-10.2f %10.2f ", $2/1024/2024, $10/1024/1024}'
        printf "%20s %20s\n" "$ESTABLISHED" "$LISTENING"
        echo "-------------------------------------------------------------------------------------"

    fi 
done 