#!/bin/bash
#This script is for creating swap memory in linux systems
#tested on BASH shell only 

#script to calculate RAM size 

#Thanks to Andre [stackoverflow.com/users/2215136/andr%c3%a9] for the answer on  stackoverflow.com/a/53186875/12058066


totalmem=0;
for mem in /sys/devices/system/memory/memory*; do
  [[ "$(cat ${mem}/online)" == "1" ]] \
    && totalmem=$((totalmem+$((0x$(cat /sys/devices/system/memory/block_size_bytes)))));
done

#one-line code
totalmem=0; for mem in /sys/devices/system/memory/memory*; do [[ "$(cat ${mem}/online)" == "1" ]] && totalmem=$((totalmem+$((0x$(cat /sys/devices/system/memory/block_size_bytes))))); done


ram_size=$((totalmem/1024**3)) 

if [ $ram_size -le 2 ]; then
  swap_size=$( expr $ram_size \* 2)
fi
if [ $ram_size -ge 2 ] && [ $ram_size -lt 32 ]; then
  swap_size=$( expr $ram_size - 2 + 4) 

fi
if [ $ram_size -ge 32 ]; then
  swap_size=$ram_size;
fi



echo "The swap size should be $swap_size GB";
 
count=$( expr  $swap_size \* 1024 / 128 );

#The  code below is based on https://aws.amazon.com/premiumsupport/knowledge-center/ec2-memory-swap-file/

echo "\nswap file creation\n"

echo "\n Grab a glass of water and drink\n\n"


sudo dd if=/dev/zero of=/swapfile bs=128M count=$count status=progress

echo "  \n\n Updating the read and write permissions for the swap file\n\n"

sudo chmod 600 /swapfile -v

echo " \n\nsetting up a Linux swap area\n\n"

sudo mkswap /swapfile

echo "\n\nmaking the swap file available for immediate use by adding the swap file to swap space\n\n"

sudo swapon /swapfile

echo "\n\nverifying the process\n\n"

sudo swapon -s

echo  "\n\nenabling the swap file at boot time by editing the /etc/fstab file.\n"

echo "/swapfile      swap      swap      defaults      0      0"  >> /etc/fstab

echo "Mission Accomplished "
