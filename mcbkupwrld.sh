#!/bin/sh

#set veriables
bkupdirect=/opt/minecraft/wrldbkups
mcunit=$(systemctl status minecraft.service | grep "/system/" | awk -F '(' '{print $2}' | awk -F ';' '{print $1}')
wrkingdirect=$(grep WorkingDirectory $mcunit | awk -F '=' '{print $2}')
worlddirect=$($wrkingdirect/"world")
#echo $worlddirect > /tmp/bkup_test.txt

#does wrldbkup directory exist? If not, create it.
if [ ! -d "$bkupdirect" ]; then {
  mkdir /opt/minecraft/wrldbkups
}
fi

#Delete 4th oldest file confirm in directory when WorkingDirectory
cd /opt/minecraft/mainsurvival/wrldbkup
if [ -e *_3_*.tar.gz ]; then  {
  rm -f *_3_*.tar.gz
}
fi
if [ -e *_2_*.tar.gz ]; then  {
  rename _2_ _3_ *_2_*.tar.gz
}
fi
if [ -e *_1_*.tar.gz ]; then  {
  rename _1_ _2_ *_1_*.tar.gz
}
fi

#function for seeing if service is running
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

#create temp files with both directories to do comparisons with diff to know when backup is complete
i=1
while [$i != 0 ]
do
  cd /opt/minecraft/mainsurvival/world
  du -hs * > /tmp/pre.txt
  cd /opt/minecraft/mainsurvival/wrldbkup/mainsurvivalbkup
  du -hs * > /tmp/post.txt

  i=$(diff /tmp/pre.txt /tmp/post.txt | wc -l);
done

rm -f /tmp/pre.txt /tmp/post.txt

#Restart Minecraft
systemctl start minecraft

#tar file and set to name of world and add timestamp
tar -czf mainsurvival_1_"$timestamp".tar.gz /opt/minecraft/mainsurvival/wrldbkup/mainsurvivalbkup
