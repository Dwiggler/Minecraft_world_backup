#!/bin/sh

#set veriables
bkupdirect=/opt/minecraft/mainsurvival/wrldbkup
mcunit=$(systemctl status minecraft.service | grep "/system/" | awk -F '(' '{print $2}' | awk -F ';' '{print $1}')
wrkingdirect=$(grep WorkingDirectory /etc/systemd/system/minecraft.service | awk -F '=' '{print $2}')
worlddirect=$($wrkingdirect"world")
#echo $worlddirect > /tmp/bkup_test.txt

#does wrldbkup directory exist? If not, create it.
if [ ! -d "$bkupdirect" ]; then {
  mkdir /opt/minecraft/mainsurvival/wrldbkup
}
fi

service_check () {
        ps -ef | grep mainsurvival | grep -v grep | wc -l
}

#Stop the minecraft service
systemctl stop minecraft
x=1
while [ $x != 0 ]; do	x=$(service_check); done

#create date/timestamp
timestamp=$(date +%Y%m%d%H%M)

#Copy file to backup directory
cp -R /opt/minecraft/mainsurvival/world /opt/minecraft/mainsurvival/wrldbkup/mainsurvivalbkup

#Restart Minecraft
systemctl start minecraft

#tar file and set to name of world and add timestamp
tar -czf mainsurvival"$timestamp".tar.gz /opt/minecraft/mainsurvival/wrldbkup/mainsurvivalbkup

#Delete 4th oldest file
