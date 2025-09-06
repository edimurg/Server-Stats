#!/bin/bash
# server_stats.sh
# A real-time resource monitoring tool
#
# Copyright (c) 2025 Murg Mihai Eduard
# Licensed under the MIT License
# See LICENSE file in the project root for more information.

trap 'tput cnorm ; echo -e " \033[00m" ; stty echo ; clear ; exit 0' INT TERM EXIT   #this is to make sure that when you close the script your cursor will be back to normal, and there will be no color changes, and it will enable back your keyboard
tput civis   #this hides your cursor
clear

delimiter() {
	echo -e "\033[1m\033[01;35m------------------------------------------------------------------\033[00m" #this is just a delimiter
}

uptime-loadaverage () {
	loadaverage=`uptime | awk -F 'load average: ' '{print $2}'`	
	uptime=(`uptime -p`)
	for i in ${uptime[@]};do		#this calculates how many elements are in the arrow

		s=$((s+1))
	done

	echo -e -n "\033[0;33mUptime\033[0m: "		
	for ((i=1 ; i<$((s+1)) ; i++))  do        	#we print the arrow without the first element

		echo -n "${uptime[i]} "
	done
	echo -e -n "        \033[0;33mLoad average\033[0m: $loadaverage"
	echo " "
}

memory(){   #this is the memory function
total_memory=`free -h | tr -d 'Gi' | awk '{print $2}' | sed '2!d'`
        echo " "
        used_memory=`free -h | tr -d 'Gi' | awk '{print $3}' | sed '2!d'`
	math=`echo "$used_memory * 100 / $total_memory / 2 " | bc`    #this will give us the usage procentage and will scale it to the bar, for every 1% of usage we will print one block 
	procentage=`echo "$math * 2 + 1" | bc `
	echo -e "\033[4m\033[1mMemory	\033[00m\033[0;36m█\033[0m Total\033[0;31m █\033[0m Used \n"
	echo -e "Total memory is $total_memory GB\n"
	echo -e "\033[0;36m▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉" #there is 50 of this blocks
	for ((i=0;i<$math;i++));do   #here we print the bar underneath the first bar (100% used memory = 50 blocks)
	echo -e -n "\033[0;31m█\033[0m"
        
done
echo -e " $used_memory GB ($procentage%)                                                \n"
}

cpu(){ 	total_cpu_usage=`top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'` #this function will monitor the cpu activity
	echo " "
	echo -e "\033[4m\033[1;97mCPU\033[0m"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 100%"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 90%"
        echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 80%"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 70%"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 60%"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 50%"   
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 40%"
	echo "▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 30%"
	echo "▇▇▇▇▇▇▇▇▇▇▇ 20%"
	echo "▇▇▇▇▇▇ 10%"
	echo "▇▇▇ 5%"
	math=`echo "$total_cpu_usage / 2 + 1 " | bc`  #scalaing the procentage to the bar
	for ((i=0;i<$math;i++));do  #underneath bar
		echo -e -n "\033[0;31m█\033[0m"
	done
       	echo -e " $total_cpu_usage%                                                 \n "
}

storage() {   # this function will monitor the sorage
	total_space=`df -h / | awk '{print $2}' | sed '2!d' | tr -d 'G'`
	used_space=`df -h / | awk '{print $3}' | sed '2!d' | tr -d 'G'`
	math=`echo "$used_space * 100 / $total_space / 2 " | bc`  # scaling the procentage to the bar
	procentage=`echo "$math * 2 + 1" | bc`		
 #this is to get the real procentage
	echo " "
	echo -e "\033[4m\033[1mStorage\033[0m   \033[00m\033[0;34m█\033[0m Total\033[0;31m █\033[0m Used \n"
	echo -e "Total Disk Space is $total_space GB\n"
	echo -e "\033[0;34m▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉" #top bar
	for ((i=0;i<$math;i++));do  #underneath bar
	echo -e -n "\033[0;31m█\033[0m"
done
echo -e " $used_space GB ($procentage%) \n                                     "
}

active_processes() {  # this function will monitor top 5 processes with the most cpu and memory needs
	echo " "
	procentage_cpu=(`echo -e "\033[4;33mCPU\033[0m" ; top -b | head -12 | awk '{print $9}' | sed '8,12!d'`)   #used cpu
	procentage_ram=(`echo -e "\033[4;33mMEM\033[0m" ; top -b | head -12 | awk '{print $10}' | sed '8,12!d'`)  #used memory
	processes=(`echo -e "\033[4;33mProcesses\033[0m" ;  top -b | head -12 | awk '{print $12}' | sed '8,12!d'`)  # the processes

	for ((s=0;s<1;s++));do
		echo "${procentage_ram[s]} ${procentage_cpu[s]} ${processes[s]}" # here we create 3 colums in paralel, memory usage, cpu usage, and the processes
	done
	for (( i=1;i<6;i++));do
		echo "${procentage_ram[i]}% ${procentage_cpu[i]}% ${processes[i]}          	"
	done
	echo " "
 } 

while true; do  #here we call all the functions and loop them in an infite loop
	stty -echo  #this disables the keyboard
	tput cup 0 0 
	uptime-loadaverage
	delimiter
	memory
	delimiter
	cpu
	delimiter
	storage
	delimiter
	active_processes
	delimiter
	echo "Press 'CTRL + c' to exit."
	sleep 1
done
