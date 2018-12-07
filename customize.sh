#!/usr/bin/env bash

#Test if the script was executed by root
[[ $(id -u) -ne "0" ]] && { echo "This script must be executed by root." ; exit 1; }

#installing fonts and apps
echo "Installing Fonts and required apps"
pacman -S ttf-font-awesome terminus-font htop xterm ranger scrot feh rofi rxvt-unicode i3status i3-gaps --noconfirm
sleep 2
clear

#installing drivers
echo "Installing drivers."
[[ $(cat /proc/cpuinfo | grep GenuineIntel) ]] && pacman -S xf86-video-intel intel-ucode xf86-video-vesa

################################################################################################
### Have to figure out if the system has a graphics card and wich grafics to install for it. ###
################################################################################################

#If ~/.wallpaper exit then move wallpaper
if [[ -d ~/.wallpaper ]] ; then
  mv wallpaper.jpg ~/.wallpaper/wallpaper.jpg
else
  mkdir -p ~/.wallpaper
  mv wallpaper.jpg ~/.wallpaper/wallpaper.jpg
fi

#If i3 config file exists make it a backup file
if [[ -e ~/.i3/config ]] ; then
  cp ~/.i3/config ~/.i3/config.backup
fi

#If i3status config file exists make it a backup file
if [[ -e /etc/i3status.conf ]] ; then
  cp /etc/i3status.conf /etc/i3status.conf.backup
fi

#If .Xdefaults exists make it a backup file
if [[ -e ~/.Xdefaults ]] ; then
  cp ~/.Xdefaults ~/.Xdefaults.backup
fi

#Move config files
mv config ~/.i3/config
mv Xdefaults ~/.Xdefaults
mv i3status.conf /etc/i3status.conf

#removing the folder
cd .. ; rm -rf i3GapsConfig
