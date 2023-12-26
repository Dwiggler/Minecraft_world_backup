#!/bin/sh

#get world directory
mcunit=$(systemctl status minecraft.service | grep "/system/" | awk -F '(' '{print $2}' | awk -F ';' '{print $1}')
workingdirectory=$(grep WorkingDirectory /etc/systemd/system/minecraft.service | awk -F '=' '{print $2}')
worlddirectory=$($workingdirectory + "/world")
echo $worlddirectory > /tmp/bkup_test.txt


#Stop the minecraft service


#create date/timestamp

#Copy file to backup directory 

#Restart Minecraft

#Change name of world file to date/timestamp for version

#Delete 4th oldest file
