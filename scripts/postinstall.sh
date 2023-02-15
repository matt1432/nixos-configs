#!/bin/sh

SSID="$1"

systemctl enable --now iwd systemd-networkd systemd-resolved systemd-timesyncd
echo "check if powered on"
iwctl device list
sleep 5
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect "$SSID"
cat << EOF >> /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

useradd -m matt -G wheel
passwd matt

pacman -Syu
pacman -Sy htop iwgtk pkgfile plocate rsync tailscale tmux usbutils wget git curl devtools xorg xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau

pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

su matt

yay -Sy alsa-utils alsa-firmware sof-firmware alsa-ucm-conf
amixer sset Master unmute

yay -Sy pipewire-audio pipewire-alsa pipewire-pulse
yay -R pulseaudio-alsa
sudo systemctl stop pulseaudio.service
systemctl --user enable --now pipewire-pulse.service