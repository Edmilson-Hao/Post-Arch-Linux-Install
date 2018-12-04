#!/usr/bin/env bash

cd /tmp
#instalando fontes
echo "Installing Fonts and required apps"
pacman -S ttf-font-awesome terminus-font htop xterm ranger scrot feh dmenu rofi --noconfirm
clear

echo "Downloading i3wm config file"
wget https://raw.githubusercontent.com/Edmilson-Hao/i3GapsConfig/master/config -O config
clear

echo "Downloading i3status config file"
wget https://raw.githubusercontent.com/Edmilson-Hao/i3GapsConfig/master/i3status.conf -O i3status.conf
clear

echo "Downloading .Xdefaults configuration."
wget https://raw.githubusercontent.com/Edmilson-Hao/i3GapsConfig/master/Xdefaults -O Xdefaults
clear

echo "Downloading Wallpaper"
wget https://raw.githubusercontent.com/Edmilson-Hao/i3GapsConfig/master/wallpaper.jpg -O wallpaper.jgp

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
