#!/usr/bin/env bash
#
#
#######################################################
##### Author: Edmilson Hao <edmilsonwp@gmail.com> #####
##### Site: http://www.estudandolinux.com.br      #####
##### Version: 0.1                                #####
##### Date: 07/12/2018 10:43:50                   #####
#######################################################
#
#MIT License
#
#Copyright (c) 2018 Edmilson-Hao
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#



#Test if the script was executed by root
[[ $(id -u) -ne "0" ]] && { clear ; echo "This script must be executed by root." ; sleep 2 ; exit 1; }


##########     Functions     ##########

function rank() {
	#Installing pacman-contrib package for some useful scripts
	echo "Ranking mirros to get the 6 fastest fot your current location."
	pacman -S pacman-contrib --noconfirm

	#Rank the 6 fastest mirrors for current location.
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

}

function installPackages() {
	#Configuring basic system

	!!!!!!!!!!!!!!!!enable multilib!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	echo "Installing xorg and drivers."
	sudo pacman -S xorg xorg-server xorg-xinit xorg-utils xorg-server-devel --noconfirm


	#installing intel drivers
	echo "Installing drivers."
	[[ $(cat /proc/cpuinfo | grep GenuineIntel) ]] && pacman -S xf86-video-intel intel-ucode xf86-video-vesa lib32-intel-dri lib32-mesa lib32-libgl --noconfirm

	#Install GPU driver. if=NVIDIA 		elif=AMD
	if [[ $(lspci | grep -i NVIDIA) ]] ; then
		pacman -S nvidia nvidia-libgl nvidia-utils nvidia-settings --noconfirm
		#&& cp /root/xorg.conf.new /etc/X11/xorg.conf
		[[ ! $(cat /usr/lib/modprobe.d/nvidia.conf | grep blacklist) ]] && echo "blacklist nouveau" >> /usr/lib/modprobe.d/nvidia.conf
	#elif [[ $(lspci | grep -i AMD ]] ; then
	#	pacman -S xf86-video-amdgpu --noconfirm

	fi

	nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia

	# xf86-video-nouveau lib32-nouveau-dri 

	
	
	
	linux-headers
	linux-firmware
	alsa-utils
	xorg-fonts-100dpi
	networkmanager
	network-manager-applet
	wireless-tools
	wpa_supplicant
	wpa_actiond
	dialog
	
	#installing fonts and apps
	echo "Installing Fonts and required apps"
	pacman -S noto-fonts ttf-font-awesome terminus-font htop xterm ranger scrot feh rofi rxvt-unicode i3status i3-gaps --noconfirm
	
	sleep 2
	clear
}


#removing the folder
function remove() {
	cd .. ; rm -rf i3GapsConfig
}

#Configuring dotfiles and wallpaper
function configWM() {
	
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
	
	configurar teclado
	hostnamectl set-hostname arch

	#Move config files
	mv config ~/.i3/config
	mv Xdefaults ~/.Xdefaults
	mv i3status.conf /etc/i3status.conf
}
