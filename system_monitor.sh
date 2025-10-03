#!/bin/bash 

# Constant Variables
HOSTNAME=$(hostname)
USER=$(whoami)

# CPU Information Variables
CPU_NAME="Intel i5" # Temp, find out a way to get the cpu name of the system and shorten it. 
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# Loop Varibale
flag=true

# Functions
function get_cpu_usage(){
    # Get the cpu information need to determine cpu usage.
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat 
    local total_cpu_time_1=$((user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice)) 
    local cpu_idle_time_1=$((idle + iowait))

    sleep 0

    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat 
    local total_cpu_time_2=$((user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice))
    local cpu_idle_time_2=$((idle + iowait))

    # Calculate the difference.
    local total_difference=$((total_cpu_time_2 - total_cpu_time_1))
    local idle_difference=$((cpu_idle_time_2 - cpu_idle_time_1))

    if [[ $idle_difference -eq 0 ]]; then 
        usage=0
        echo -n "$usage"
    fi

    usage=$((100 * (total_difference - idle_difference) / total_difference))  

    echo -n "$usage"
}

echo 

echo "General System Information" 
echo "-------------------------------------------------"
printf "%-20s %10s %10s\n" "Hostname" "User" "OS"
echo "-------------------------------------------------"
printf "%-20s %10s %10s\n" "$HOSTNAME" "$USER" "$OSTYPE"
echo "-------------------------------------------------"

echo 

echo "CPU Information" 
echo "-----------------------------------------------"
printf "%-20s %10s %10s\n" "CPU Name" "Cores" "Usage%"
echo "-----------------------------------------------"
printf "%-20s %10s %10s\n" "$CPU_NAME" "$CPU_CORES" "0%"
echo "-----------------------------------------------"

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
echo "------------------------------------------------------------------------------"
printf "%-10s %10s %20s %20s\n" "RX (MB)" "TX (MB)" "Active Connection" "Listening Services"
echo "------------------------------------------------------------------------------"
printf "%-10s %10s %20s %20s\n" "0" "0" "0" "0"
echo "------------------------------------------------------------------------------"

# Save the original cursor
tput sc

# Save the coordinates of the cpu usage information and network RT/TX information.
cpu_usage_col=$((39))
cpu_usage_row=$(($(tput lines) - 34))


while true; do
    # Updating cpu usage infromation
    usage=$(get_cpu_usage)

    tput civis
    tput rc
    tput cup $cpu_usage_row $cpu_usage_col
    printf "%-4s" "${usage}%"

    tput cup 47 0
    tput cnorm

    sleep 1

    read -t 1 -p "" user
    if [[ $user == "q" ]]; then
        echo 
        echo "Exiting ..."
        break
    fi
done