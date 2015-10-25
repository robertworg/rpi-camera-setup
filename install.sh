#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo -n "Enter new hostname:"
read HOSTNAME
echo "Hostname set to $HOSTNAME"

# prompt for SSID and password
echo -n "SSID for WIFI access point: "
read SSID
echo "Access point set to $SSID"
echo -n "Password for $SSID: "
read PSK
echo "Password set to $PSK"

# set hostname
[ $(./replace-in-file.py -p '/etc/hostname' -fs 'raspberrypi' -rs "$HOSTNAME") ]
[ $(./replace-in-file.py -p '/etc/hosts' -fs 'raspberrypi' -rs "$HOSTNAME") ]

WPA_SUP=$(pwd)"/wpa_supplicant.conf"
WPA_SUP_NEW=$WPA_SUP".new"
INTERFACES=$(pwd)"/interfaces"

# create a .new file to write to, then move it to wpa_supplicant folder
cp $WPA_SUP $WPA_SUP_NEW

[ $(./replace-string-in-file.py -p $WPA_SUP_NEW -fs 'ssid=""' -rs "ssid=\"$SSID\"") ]
[ $(./replace-string-in-file.py -p $WPA_SUP_NEW -fs 'psk=""' -rs "psk=\"$PSK\"")]

mv $WPA_SUP_NEW /etc/wpa_supplicant/wpa_supplicant.conf

cp interfaces /etc/network/interfaces

# updates for camera streaming
apt-get update
apt-get --yes upgrade
apt-get -y install vim libav-tools git python-setuptools python-pip python-picamera
pip install ws4py

apt-get --yes  install gcc-4.8 g++-4.8
wget http://node-arm.herokuapp.com/node_latest_armhf.deb
sudo dpkg -i node_latest_armhf.deb

printf "\nReboot your PI\n"
