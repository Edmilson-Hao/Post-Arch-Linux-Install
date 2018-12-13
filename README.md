# ArchLinux Post install
This script aims to be an easy way to configure a fresh Arch Linux install.

The script will setup a minimal enviroment with i3-gaps window manager configured to work out of the box.

The script must have execute permission (chmod +x postarch.sh).
You must run it as toor to use pacman to install some packages.

List of packages installed by the script.\n
1 - xf86-video-intel -> I will add AMD and Nvidia drivers later.
2 - xf86-video-vesa -> As a fallback.
3 - intel-ucode or amd-ucode -> Intel or AMD microcode.
4 - ttf-font-awesome -> For the icons on i3status.
5- terminus-font -> For system and terminal font.
6 - htop.
5 - xterm
6 - ranger - As file manager.
5 - scrot -> To take screenshots.
6 - feh - to set wallpapers.
7 - rofi - As the application launcher.
