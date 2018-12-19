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
global myUser

####################   Functions    ####################

#Menu
function mainMenu(){
cat << EOF




                                        ________________________________________________________________________
                                        |                                                                      |
                                        |         (1) - Get mirrors.                                           |
                                        |         (2) - Install xorg and drivers.                              |
                                        |         (3) - Install i3-gaps and apps.                              |
                                        |         (4) - Create user and configure sud.                         |
                                        |         (5) - Configure dotfiles.                                    |
                                        |         (6) - Exit.                                                  |
                                        |______________________________________________________________________|
EOF
}

function menuMirrors(){
cat << MIRRORLIST





                               ____________________________________________________________________________________
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
read -r mirrorOption

curl -o mirrorlist https://www.archlinux.org/mirrorlist/?country=$mirrorOption&protocol=http&protocol=https&ip_version=4
sleep 1
}

function getMirrors() {
	clear
	#Backingup mirrorlist
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

	menuMirrors
	sleep 1
	mv mirrorlist /etc/pacman.d/mirrorlist
	sed -i 's/#Server/Server/' /etc/pacman.d/mirrorlist

}


#Configuring xorg and drivers
function installXorgDriver() {
	clear

	#Enable multilib
	echo "[multilib]" >> /etc/pacman.conf
	echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

	#Installing xorg
	pacman -Sy xorg xorg-server xorg-xinit xorg-xrdb


	#installing intel drivers
	[[ $(cat /proc/cpuinfo | grep -i intel) ]] && pacman -S xf86-video-intel intel-ucode xf86-video-vesa lib32-intel-dri lib32-mesa lib32-libgl

	#Install GPU driver. if=NVIDIA 		elif=AMD
	if [[ $(lspci | grep -i NVIDIA) ]] ; then
		pacman -S nvidia nvidia-libgl nvidia-utils nvidia-settings opencl-nvidia
		#&& cp /root/xorg.conf.new /etc/X11/xorg.conf
		[[ ! $(cat /usr/lib/modprobe.d/nvidia.conf | grep -i blacklist) ]] && echo "blacklist nouveau" >> /usr/lib/modprobe.d/nvidia.conf
	fi

	if [[ $(lspci | grep -i AMD) ]] ; then
		pacman -S xf86-video-amdgpu

	fi

}

#Installing Window Manager and Apps
function installApps(){
	#installing fonts and apps
	pacman -S vim ttf-font-awesome terminus-font htop xterm ranger scrot feh rofi rxvt-unicode i3status i3-gaps alsa-utils compton firefox arc-gtk-theme lxappearance papirus-icon-theme
	sleep 2
	clear
}

function createUser(){
  	echo "Enter your user name: "
    read myUser
    useradd -m -g wheel -G video,storage,scanner,optical,kvm,input,floppy,disk,audio -s /bin/bash $myUser

    pacman -S sudo
    echo "exec i3" >> /home/$myUser/.xinitrc
    echo "startx" >> /home/$myUser/.bash_profile
  	passwd $myUser
  	sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
}

#####################################################################################

#Test if the script was executed by root
[[ $(id -u) -ne "0" ]] && { clear ; echo "This script must be executed by the root user." ; sleep 2 ; exit 1; }

option=1
while [ $option -ne 6 ] ; do
	clear
	mainMenu
	read option

	case $option in
		1) getMirrors ;;
		2) installXorgDriver ;;
		3) installApps ;;
		4) createUser ;;
		5) remove ; break ;;
	esac
done
