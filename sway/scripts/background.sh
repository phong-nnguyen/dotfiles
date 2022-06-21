#!/usr/bin/bash

###Variables###

#If you wanna use the script, change the walDir with where your wallpapers are located
#Background logger automatically makes a txt file in your sway config, change if you want
walDir=$(find ~/Images/bkgrnd)
File="$HOME/.config/sway/scripts/startUpBg.txt"

#Keep these variables the same
dir=$(find $walDir -type f | shuf -n1)
oldWP=$(ps aux |grep swaybg | awk -F ' ' '{print $13}' | grep /)



#Makes the file containing the log of previous wallpaper directories
#Used to set same wallpaper on startup
if [ ! -e $File ]; then
	echo "Creating startup background logger"
	touch $File
fi


#Wallpaper setter, checks if there is a current instance of swaybg running first
if pidof -x "swaybg" > /dev/null
then
	while [ $dir == $oldWP ]
	do
		dir=$(find $walDir -type f | shuf -n1)
	done
	#Append new wallpaper directories into wallpaper logger
	echo $dir >> $File
	PID=`pidof swaybg`
	swaybg -i $dir -m fill &
	sleep 1
	kill $PID
	wal -n -i $dir
	sleep 1
else
	if [ -s $File ]
	then
		beforeStartUp=$(tail -n 1 $File)
		swaybg -i $beforeStartUp -m fill &
		wal -n -i $beforeStartUp
		: > $File
		echo $beforeStartUp >> $File
	else
		dir=$(find $walDir -type f | shuf -n1)
		swaybg -i $dir -m fill &
		wal -n -i $dir
		echo $dir >> $File
	fi
fi

