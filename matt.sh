#!/bin/sh
yay -Sy networkmanager-iwd
sudo systemctl enable NetworkManager

yay -Sy alsa-utils alsa-firmware sof-firmware alsa-ucm-conf
amixer sset Master unmute

yay -Sy pipewire-audio pipewire-alsa pipewire-pulse
yay -R pulseaudio-alsa
sudo systemctl stop pulseaudio.service
systemctl --user enable --now pipewire-pulse.service

yay -Sy baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-console gnome-contacts gnome-control-center gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gnome-menus gnome-music gnome-photos gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-user-docs gnome-user-share gnome-video-effects grilo-plugins nautilus rygel simple-scan sushi totem tracker3-miners xdg-user-dirs-gtk yelp

yay -Sy dconf-editor evolution gnome-nettool gnome-tweaks gnome-usage gnome-themes-extra adwaita-dark extension-manager tailscale-systray-git galaxybudsclient-bin hplip cups nextcloud-client grub-customizer

yay -Sy gnome-shell-extension-extensions-sync-git

cd /tmp
git clone https://github.com/matt1432/dash-to-panel-touch-fix.git
cd dash-to-panel-touch-fix/
make install

sudo systemctl enable --now gdm