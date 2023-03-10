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

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sed -i 's/#DNS=.*/DNS=100.64.0.1/' /etc/systemd/resolved.conf
sed -i 's/#FallbackDNS=.*/FallbackDNS=1.1.1.1/' /etc/systemd/resolved.conf

systemctl restart iwd systemd-resolved

cat << EOF >> /var/lib/iwd/ CLG.8021x
[IPv6]
Enabled=true

[Security]
EAP-Method=PEAP
EAP-Identity=USER
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=USER
EAP-PEAP-Phase2-Password=PASSWD
EOF
nano /var/lib/iwd/CLG.8021x

pacman -Sy reflector
nano /etc/xdg/reflector/reflector.conf 
systemctl enable --now reflector.timer

useradd -m matt -G wheel
passwd matt

pacman -Syu
pacman -Sy htop pkgfile plocate rsync tailscale tmux usbutils wget git curl devtools xorg xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau bash-completion fzf

systemctl enable --now tailscale

su matt