#sed -i 's/#Server/Server/' mirrorlist

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

####################	Functions     ####################	

#Menu
function mainMenu(){
cat << EOF


          ________________________________________________________________________
          |                                                                      |
          |         (1) - Get mirrors.                                           |
          |         (2) - Install xorg and drivers.                              |
          |         (3) - Install i3-gaps and apps.                              |
          |         (4) - Configure dotfiles.                                    |
          |         (5) - Create user and configure sudo.                        |
          |         (6) - Exit.                                                  |
          |______________________________________________________________________|
EOF
}

function menuMirros(){
cat << MIRRORLIST
______________________________________________________________________________________
|       A                         |                       |          P               |
|(AU) - Australia                 | (HU) - Hungary        | (PT) - Portugal          |
|(AT) - Austria                   |        I              |        Q                 |
|       B                         | (IS) - Iceland        | (QA) - Qatar             |
|(BD) - Bangladesh                | (IN) - India          |        R                 |
|(BY) - Belarus                   | (ID) - Indonesia      | (RO) - Romania           |
|(BE) - Belgium                   | (IR) - Iran           | (RU) - Russia            |
|(BA) - Bosnia and Herzegovina    | (IE) - Ireland        |        S                 |
|(BR) - Brazil                    | (IL) - Israel         | (RS) - Serbia            |
|(BG) - Bulgaria                  | (IT) - Italy          | (SG) - Singapore         |
|       C                         |        J              | (SK) - Slovakia          |
|(CA) - Canada                    | (JP) - Japan          | (SI) - Slovenia          |
|(CL) - Chile                     |        K              | (ZA) - South Africa      |
|(CN) - China                     | (KZ) - Kazakhstan     | (KR) - South Korea       |
|(CO) - Colombia                  | (KE) - Kenya          | (ES) - Spain             |
|(HR) - Croatia                   |        L              | (SE) - Sweden            |
|(CZ) - Czechia                   | (LV) - Latvia         | (CH) - Switzerland       |
|       D                         | (LT) - Lithuania      |        T                 |
|(DK) - Denmark                   | (LU) - Luxembourg     | (TW) - Taiwan            |
|       E                         |        M              | (TH) - Thailand          |
|(EC) - Ecuador                   | (MK) - Macedonia      | (TR) - Turkey            |
|       F                         | (MX) - Mexico         | (UA) - Ukraine           |
|(FI) - Finland                   |        N              | (GB) - United Kingdom    |
|(FR) - France                    | (NL) - Netherlands    | (US) - United States     |
|       G                         | (NC) - New Caledonia  | (VN) - Vietnam           |
|(GE) - Georgia                   | (NZ) - New Zealand    |                          |
|(DE) - Germany                   | (NO) - Norway         |                          |
|(GR) - Greece                    |        P              |                          |
|       H                         | (PY) - Paraguay       |                          |
|(HK) - Hong Kong                 | (PH) - Philippines    |                          |
|(HU) - Hungary                   | (PL) - Poland         |                          |
|____________________________________________________________________________________|

Select your mirror: 
MIRRORLIST
read mirrorOption

curl -o mirrorlist https://www.archlinux.org/mirrorlist/?country=$mirrorOption&protocol=http&protocol=https&ip_version=4
sleep 1
}

function getMirrors() {
	urlOne="https://www.archlinux.org/mirrorlist/?country="
	urlTwo="&protocol=http&protocol=https&ip_version=4"
	clear
	#Backingup mirrorlist
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	
	selectMirror
	sleep 1
	mv mirrorlist /etc/pacman.d/mirrorlist
}


#Configuring xorg and drivers
function installXorgDriver() {
	clear

	#Enable multilib
	echo "[multilib]" >> /etc/pacman.conf
	echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
	
	#Installing xorg
	pacman -Sy xorg-server xorg-fonts-100dpi xorg-xinit xorg-server-devel alsa-utils network-manager-applet networkmanager wireless-tools wpa-supplicant wpa-actiond dialog linux-headers --noconfirm

	#installing intel drivers
	[[ $(cat /proc/cpuinfo | grep -i intel) ]] && pacman -S xf86-video-intel intel-ucode xf86-video-vesa lib32-intel-dri lib32-mesa lib32-libgl --noconfirm

	#Install GPU driver. if=NVIDIA 		elif=AMD
	if [[ $(lspci | grep -i NVIDIA) ]] ; then
		pacman -S nvidia nvidia-libgl nvidia-utils nvidia-settings opencl-nvidia --noconfirm
		#&& cp /root/xorg.conf.new /etc/X11/xorg.conf
		[[ ! $(cat /usr/lib/modprobe.d/nvidia.conf | grep -i blacklist) ]] && echo "blacklist nouveau" >> /usr/lib/modprobe.d/nvidia.conf
	fi

	if [[ $(lspci | grep -i AMD) ]] ; then
		pacman -S xf86-video-amdgpu --noconfirm

	fi

}

#Installing Window Manager and Apps
function installApps(){
	#installing fonts and apps
	pacman -S vim noto-fonts ttf-font-awesome terminus-font htop xterm ranger scrot feh rofi rxvt-unicode i3status i3-gaps --noconfirm
	read	
	sleep 2
	clear
}

#Configuring dotfiles and wallpaper
function configWM() {
	clear

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

function createUser(){
	echo "Enter your user name: "
	read myUser
	useradd -m -g wheel -G video,storage,scanner,optical,kvm,input,floppy,disk,audio -s /bin/bash $myUser
	passwd $myUser
}

#removing the folder
function remove() {
	cd .. ; rm -rf i3GapsConfig
}

#####################################################################################

#Test if the script was executed by root
[[ $(id -u) -ne "0" ]] && { clear ; echo "This script must be executed by the root user." ; sleep 2 ; exit 1; }

clear
option=1
while [ $option -ne 5 ] ; do
	clear
	mainMenu
	read option

	case $option in	
		1) getMirrors ;;
		2) installXorgDriver ;;
		3) installApps ;;
		4) configWM ;;
		5) createUser ;;
		6) remove ; break ;;
	esac
done
