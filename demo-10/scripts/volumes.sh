#!/bin/bash

set -ex 

#it referesh the LVM state to see if the LVM volumes already present
vgchange -ay

# then we're going to look for DEVICE variable which is "xvdh" volume we used to attach in instance file
# thie below command will output the file system of device
# if it doesn't have a file system, then it will create a physical volume, logical volum named "volume1" and then format it
# if it has, then it go to the line 31 -> "mkdir -p /data"
DEVICE_FS=`blkid -o value -s TYPE ${DEVICE} || echo ""`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi
# then we will make a directory to mount (if it's not created yet. -p will check it)
# and then we'll add it to fstab if its not added yet and then we mount it
mkdir -p /data
echo '/dev/data/volume1 /data ext4 defaults 0 0' >> /etc/fstab
mount /data

# install docker
curl https://get.docker.com | bash
