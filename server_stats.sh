#!/bin/bash

# server_stats.sh
# A resources monitoring tool

# Copyright (c) 2025 Murg Mihai Eduard
# Licensed under the MIT License
# See LICENSE file in the project root for more information.

screen_size_error_handling(){     #we need this because of how tput works, if you do not meet the minimum requirement of lines and cols the script will break
	rows=$(tput lines)
	cols=$(tput cols)
	if [ $rows -gt 49 ] && [ $cols -gt 67 ];then
		main
	else
		echo -e "\033[0;31mWarning !\033[0m\n" 
		echo "Your terminal window is too small (You have $rows rows x $cols cols)."
		echo "You need at least 49 rows and 67 cols."
		echo "Check with 'tput lines' for rows and 'tput cols' for cols."
		echo -e "Try to use fullscreen or lower your text font size.\n"
		echo "Do you still want to continue ? (Y/n)"
		read yes_or_no
		if [ $yes_or_no = 'Y' ] || [ $yes_or_no = 'y' ];then
			main
		else 
			clear
			echo -e "\033[0;32m[INFO]\033[0m Exited succesfully."
		       sleep 5
		fi

	fi
}

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
	echo -e -n "      \033[0;33mLoad average\033[0m: $loadaverage"
	echo " "
}

memory(){   #this is the memory function
total_memory=`free -h | tr -d 'Gi' | awk '{print $2}' | sed '2!d'`
        echo " "
        used_memory=`free -h | tr -d 'Gi' | awk '{print $3}' | sed '2!d'`
	math=`echo "$used_memory * 100 / $total_memory / 2 " | bc`    #this will give us the usage precentage and will scale it to the bar, for every 1% of usage we will print one block 
	precentage=`echo "$math * 2 + 1" | bc `
	echo -e "\033[4m\033[1mMemory	\033[00m\033[0;36m█\033[0m Total\033[0;31m █\033[0m Used \n"
	echo -e "Total memory is $total_memory GB\n"
	echo -e "\033[0;36m▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉" #there is 50 of this blocks
	for ((i=0;i<$math;i++));do   #here we print the bar underneath the first bar (100% used memory = 50 blocks)
	echo -e -n "\033[0;31m█\033[0m"
        
done
echo -e " $used_memory GB ($precentage%)                                                \n"
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
	math=`echo "$total_cpu_usage / 2 + 1 " | bc`  #scalaing the precentage to the bar
	for ((i=0;i<$math;i++));do  #underneath bar
		echo -e -n "\033[0;31m█\033[0m"
	done
       	echo -e " $total_cpu_usage%                                                 \n "
}

storage() {   # this function will monitor the sorage
	total_space=`df -h / | awk '{print $2}' | sed '2!d' | tr -d 'G'`
	used_space=`df -h / | awk '{print $3}' | sed '2!d' | tr -d 'G'`
	math=`echo "$used_space * 100 / $total_space / 2 " | bc`  # scaling the precentage to the bar
	precentage=`echo "$math * 2 + 1" | bc`		
 #this is to get the real precentage
	echo " "
	echo -e "\033[4m\033[1mStorage\033[0m   \033[00m\033[0;34m█\033[0m Total\033[0;31m █\033[0m Used \n"
	echo -e "Total Disk Space is $total_space GB\n"
	echo -e "\033[0;34m▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉" #top bar
	for ((i=0;i<$math;i++));do  #underneath bar
	echo -e -n "\033[0;31m█\033[0m"
done
echo -e " $used_space GB ($precentage%) \n                                     "
}

active_processes() {  # this function will monitor top 5 processes with the most cpu and memory needs
	echo " "
	precentage_cpu=(`echo -e "\033[4;33mCPU\033[0m" ; top -b | head -12 | awk '{print $9}' | sed '8,12!d'`)   #used cpu
	precentage_ram=(`echo -e "\033[4;33mMEM\033[0m" ; top -b | head -12 | awk '{print $10}' | sed '8,12!d'`)  #used memory
	processes=(`echo -e "\033[4;33mProcesses\033[0m" ;  top -b | head -12 | awk '{print $12}' | sed '8,12!d'`)  # the processes

	for ((s=0;s<1;s++));do
		echo "${precentage_ram[s]} ${precentage_cpu[s]} ${processes[s]}" # here we create 3 colums in paralel, memory usage, cpu usage, and the processes
	done
	for (( i=1;i<6;i++));do
		echo "${precentage_ram[i]}% ${precentage_cpu[i]}% ${processes[i]}          	"
	done
	echo " "
 } 

main (){
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
}

screen_size_error_handling
