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

# TODO : Add school wifi settings and https://man.archlinux.org/man/reflector.1#EXAMPLES (update README)

useradd -m matt -G wheel
passwd matt

pacman -Syu
pacman -Sy htop pkgfile plocate rsync tailscale tmux usbutils wget git curl devtools xorg xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau bash-completion fzf

sudo systemctl enable --now tailscale

pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
yay -Sy networkmanager-iwd
sudo systemctl enable NetworkManager

su matt

yay -Sy alsa-utils alsa-firmware sof-firmware alsa-ucm-conf
amixer sset Master unmute

yay -Sy pipewire-audio pipewire-alsa pipewire-pulse
yay -R pulseaudio-alsa
sudo systemctl stop pulseaudio.service
systemctl --user enable --now pipewire-pulse.service

yay -Sy baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-console gnome-contacts gnome-control-center gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gnome-menus gnome-music gnome-photos gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-user-docs gnome-user-share gnome-video-effects grilo-plugins nautilus rygel simple-scan sushi totem tracker3-miners xdg-user-dirs-gtk yelp

yay -Sy dconf-editor evolution gnome-nettool gnome-tweaks gnome-usage gnome-themes-extra adwaita-dark extension-manager gnome-shell-extension-appindicator gnome-shell-extension-rounded-window-corners gnome-shell-extension-clipboard-indicator gnome-shell-extension-gsconnect gnome-shell-extension-bluetooth-quick-connect gnome-shell-extension-compiz-windows-effect-git gnome-shell-extension-quick-settings-tweaks-git tailscale-systray-git

cd /tmp
git clone https://github.com/matt1432/dash-to-panel-touch-fix.git
cd dash-to-panel-touch-fix/
make install

sudo systemctl enable --now gdm

echo logout