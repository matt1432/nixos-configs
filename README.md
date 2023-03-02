# Lenovo Yoga 6 13ALC7
This repo is a documentation of how I installed Arch and got all the drivers for the Yoga 6, to make it work as if it was native.
Since I got the [touchpad issues](https://www.reddit.com/r/Lenovo/comments/yzs5fq/faulty_touchpad_tried_everything_to_fix_it_and_i/), I'll need this once I get it fixed.
<br/><br/>

# Local Pacman repo
The latest linux kernels do not have the laptop's Wifi card's drivers, therefore I'll need a [custom repository](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Installing_packages_from_a_CD/DVD_or_USB_stick) to complete the ach installation.

<details>
<summary>Repo Packages</summary>

```
base
linux-firmware
linux
amd-ucode

patch
dkms
kmod
rtw89-dkms-git
btrfs-progs

grub
os-prober
ntfs-3g
efibootmgr
efivar

iwd
nano
sudo
texinfo
man-db
```
</details>
<br/><br/>

On a separate Arch installation with Wifi access, enter the following commands in a clean directory in a USB key :
```
git clone https://aur.archlinux.org/rtw89-dkms-git.git 
cd rtw89-dkms-git
makepkg
mv *.pkg.tar.zst ..
cd .. && sudo rm -r rtw89-dkms-git

mkdir /tmp/blankdb

pacman -Syw --cachedir . --dbpath /tmp/blankdb base linux-firmware linux amd-ucode patch dkms kmod btrfs-progs grub os-prober ntfs-3g efibootmgr efivar iwd nano sudo texinfo man-db man-pages

repo-add ./custom.db.tar.gz ./*
```
<br/><br/>

# Archinstaller
loadkeys ca

## Partionning with [cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition)
### Encrypting root partition
```
# cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p?
# cryptsetup open /dev/nvme0n1p? root
# mkfs.btrfs /dev/mapper/root
# mount /dev/mapper/root /mnt
```
### Mounting boot :
```
# mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

### Installing packages on the device
mount usb key and edit pacman.conf
```
# pacstrap -K /mnt base linux-firmware linux amd-ucode patch dkms kmod rtw89-dkms-git btrfs-progs grub os-prober ntfs-3g efibootmgr efivar iwd nano sudo texinfo man-db man-pages
```

## Preparing for chroot
```
# genfstab -U /mnt >> /mnt/etc/fstab
# arch-chroot /mnt
```

# Chroot in Installed Arch
```
# ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
# hwclock --systohc
# echo matt-laptop > /etc/hostname
# passwd
```

## Localization
Uncomment ca_FR.UTF-8 en_CA.UTF-8 en_US.UTF-8 fr_CA.UTF-8 and run 
```
# locale-gen
# echo LANG=en_CA.UTF-8 > /etc/locale.conf
# echo KEYMAP=ca > /etc/vconsole.conf
```
## Edit /etc/mkinitcpio.conf for LUKS
```
BINARIES=(btrfs)
...
HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```
then run ```mkinitpcio -P```

## Grub install
```
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch
```

### Edit /etc/default/grub for LUKS
```
cryptdevice=UUID=??????:root root=/dev/mapper/root
```
make sure the UUID is the actual partition inside the LUKS container and run ```grub-mkconfig -o /boot/grub/grub.cfg```

we can now reboot to the installed Arch
<br/><br/>

# Inside installed Arch

## Configure [internet](https://wiki.archlinux.org/title/Iwd) access
```
# systemctl enable --now iwd systemd-networkd systemd-resolved systemd-timesyncd
# iwctl device list # check if powered on
# iwctl station wlan0 scan
# iwctl station wlan0 get-networks
# iwctl station wlan0 connect SSID
# cat << EOF >> /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF
```

### Configure systemd-resolved
```
# ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
# sed -i 's/#DNS=.*/DNS=100.64.0.1/' /etc/systemd/resolved.conf
# sed -i 's/#FallbackDNS=.*/FallbackDNS=1.1.1.1/' /etc/systemd/resolved.conf
```

### Configure reflector for mirror management of pacman
```
# pacman -Sy reflector
# nano /etc/xdg/reflector/reflector.conf 
# systemctl enable --now reflector.timer
```

## User management
```
# useradd -m matt -G wheel
# passwd matt
```

## A lot of packages to install
```
htop
pkgfile
plocate
rsync
tailscale
tmux
usbutils
wget
git
curl
devtools
xorg
xf86-video-amdgpu
mesa
lib32-mesa
vulkan-radeon
lib32-vulkan-radeon
libva-mesa-driver
lib32-libva-mesa-driver
mesa-vdpau
lib32-mesa-vdpau
bash-completion
fzf
```

## Install [yay](https://github.com/Jguer/yay) and install tweaked NetworkManager
```
# pacman -S --needed git base-devel
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si

# sudo sed -i 's/#Color/Color/' /etc/pacman.conf

# yay -Sy networkmanager-iwd
# sudo systemctl enable NetworkManager
```

## Audio
### ALSA
```
yay -Sy alsa-utils alsa-firmware sof-firmware alsa-ucm-conf

#unmute speakers
amixer sset Master unmute
```

### Pipewire
```
yay -Sy pipewire-audio pipewire-alsa pipewire-pulse
yay -R pulseaudio-alsa
systemctl stop pulseaudio.service
```

## Install Gnome
```
# yay -Sy baobab cheese eog evince file-roller gdm gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-color-manager gnome-console gnome-contacts gnome-control-center gnome-disk-utility gnome-font-viewer gnome-keyring gnome-logs gnome-menus gnome-music gnome-photos gnome-remote-desktop gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-user-docs gnome-user-share gnome-video-effects grilo-plugins nautilus rygel simple-scan sushi totem tracker3-miners xdg-user-dirs-gtk yelp
```

### Download some apps and extensions
```
# yay -Sy dconf-editor evolution gnome-nettool gnome-tweaks gnome-usage gnome-themes-extra adwaita-dark extension-manager tailscale-systray-git galaxybudsclient-bin hplip cups nextcloud-client grub-customizer

## Download extensions and restore from Extensions Sync : 
# yay -Sy gnome-shell-extension-extensions-sync-git
```

### Build and install my fork of Dash to Panel
```
# cd /tmp
# git clone https://github.com/matt1432/dash-to-panel-touch-fix.git
# cd dash-to-panel-touch-fix/
# make install
```

### Enable GDM to launch the Desktop Environment
```
systemctl enable --now gdm
```

## Here are some random changes and tweaks

### Firefox touchscreen [tweak](https://wiki.archlinux.org/title/Firefox/Tweaks#Enable_touchscreen_gestures)
```
# echo MOZ_USE_XINPUT2 DEFAULT=1 >> /etc/security/pam_env.conf
```
then logout

### AUR Packages that are most likely needed
```
# yay -Sy iio-sensor-proxy-git spotify-edge vscodium-bin # yoga-usage-mode-dkms-git ?
# sudo reboot
```

### Flatpak
```
# flatpak install com.unity.UnityHub com.vscodium.codium org.freedesktop.Sdk.Extension.dotnet6 org.freedesktop.Sdk.Extension.mono6 com.github.iwalton3.jellyfin-media-player com.github.tchx84.Flatseal org.gtk.Gtk3theme.Breeze-Dark ch.openboard.OpenBoard
# FLATPAK_ENABLE_SDK_EXT=dotnet6,mono6 flatpak run com.vscodium.codium
# sudo flatpak override --filesystem=xdg-config/gtk-3.0
``` 

### vscodium on Flatpak
```
# CD=$(pwd)
# mkdir /tmp/host && cd /tmp/host
# curl -s https://api.github.com/repos/1player/host-spawn/releases \
| grep -m 1 "browser_download_url.*x86_64" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
# mv * host-spawn
# sudo chmod 755 host-spawn

# mkdir ~/bin
# sudo mv host-spawn /home/matt/bin

# cd $CD
# cp settings.json ~/.var/app/com.vscodium.codium/config/VSCodium/User/
# sudo ln -s /home/matt/bin/host-spawn /var/lib/flatpak/app/com.vscodium.codium/current/**/files/bin/git-lfs

# sudo mv /var/lib/flatpak/app/com.vscodium.codium/current/active/export/share/applications/com.vscodium.codium.desktop{,.bak}
# sudo mv /var/lib/flatpak/exports/share/applications/com.vscodium.codium.desktop{,.bak}
```

## Fingerprint Sensor Hack
### Flash [firmware](https://github.com/goodix-fp-linux-dev/goodix-fp-dump)
```
# yay -Sy python pam-fprint-grosshack
# cd /tmp
# git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
# cd goodix-fp-dump
# python -m venv .venv
# source .venv/bin/activate
# pip install -r requirements.txt
# sudo python3 run_55b4.py
```

### Install experimental [drivers](https://github.com/TheWeirdDev/libfprint/tree/55b4-experimental)
```
# yay -Sy libfprint-goodixtls-55x4 fprintd
# sudo systemctl enable --now fprintd
# fprintd-enroll
```

### Use the reader
add this to the top of every file in /etc/pam.d/ that you want ie. sddm, kde, polkit-1, sudo uwu
```
auth            sufficient      pam_fprintd_grosshack.so
auth            sufficient      pam_unix.so try_first_pass nullok
```

## Finally, install dotfiles
```
# mkdir ~/git && cd ~/git
# git clone git@git.nelim.org:matt1432/dotfiles.git
# cd dotfiles
# sudo bash setup.sh
# sudo chown matt:matt /home/matt/.env
# sed -i 's/USER=""/USER="matt"/'
# sudo bash fzf.sh /usr/share/fzf
```

TODO: make sed commands for mkinitcpio
