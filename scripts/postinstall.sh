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

yay -Sy bluedevil breeze breeze-gtk discover drkonqi kactivitymanagerd kde-cli-tools kde-gtk-config kdecoration kdeplasma-addons kgamma5 khotkeys kinfocenter kmenuedit kpipewire kscreen kscreenlocker ksshaskpass ksystemstats kwallet-pam kwayland-integration kwin ayer-shell-qt libkscreen libksysguard milou oxygen-sounds plasma-browser-integration plasma-desktop plasma-disks plasma-integration  plasma-nm plasma-pa plasma-sdk plasma-systemmonitor plasma-thunderbolt 	plasma-vault plasma-workspace plasma-workspace-wallpapers polkit-kde-agent powerdevil sddm-kcm systemsettings xdg-desktop-portal-kde
yay -R sddm
yay -Sy sddm-git plasma-wayland-session akonadi-calendar-tools ark colord-kde dolphin dolphin-plugins ffmpegthumbs filelight grantlee-editor gwenview kalendar kamera kamoso kapptemplate kcalc kcolorchooser kcron kdebugsettings kdeconnect kdegraphics-thumbnailers kdenetwork-filesharing kdenlive kdepim-addons kdesdk-thumbnailers kdf kdialog kfind kget kgpg kmag kompare konsole korganizer krdc krfb kruler ksystemlog kwalletmanager markdownpart okular gparted pim-data-exporter print-manager signon-kwallet-extension spectacle svgpart maliit-keyboard
sudo systemctl enable --now sddm