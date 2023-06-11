# Archinstaller
```
loadkeys ca
setfont ter-132b
```

## Partionning with [cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition)
### Encrypting root partition
```
$ PART="encrypted partition number ie. 2"
$ cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p$PART
$ cryptsetup open /dev/nvme0n1p$PART root
$ mkfs.btrfs /dev/mapper/root
$ mount /dev/mapper/root /mnt
```
### Mounting boot :
```
$ mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

### Installing packages on the device
```
$ pacstrap -K /mnt base linux-firmware linux amd-ucode patch dkms kmod btrfs-progs grub os-prober ntfs-3g efibootmgr efivar networkmanager iwd nano sudo texinfo man-db man-pages
```

## Preparing for chroot
```
$ genfstab -U /mnt >> /mnt/etc/fstab
$ arch-chroot /mnt
```

# Chroot in Installed Arch
```
$ ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
$ hwclock --systohc
$ echo matt-laptop > /etc/hostname
$ passwd
```

## Localization
Uncomment ca_FR.UTF-8 en_CA.UTF-8 en_US.UTF-8 fr_CA.UTF-8 and run 
```
$ locale-gen
$ echo LANG=en_CA.UTF-8 > /etc/locale.conf
$ echo KEYMAP=ca > /etc/vconsole.conf
```
## Edit /etc/mkinitcpio.conf for LUKS
```
$ sed -i 's/BINARIES=.*/BINARIES=(btrfs)/' /etc/mkinitcpio.conf
...
$ sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt filesystems fsck)/' /etc/mkinitcpio.conf
```
then run ```mkinitpcio -P```

## Grub install
```
$ grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=wim --boot-directory=/boot/EFI/wim
```

### Edit /etc/default/grub for LUKS
```
$ CRYPT="cryptdevice=$(blkid | sed -n 's/.*nvme0n1p'$PART': \(.*\) TYPE.*/\1/p'):root"
$ sed -i 's#GRUB_CMDLINE_LINUX_DEFAULT.*#GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel 3 '$CRYPT' root=/dev/mapper/root"#' /etc/default/grub
```
make sure the UUID is the actual partition inside the LUKS container and run ```grub-mkconfig -o /boot/EFI/wim/grub/grub.cfg```

we can now reboot to the installed Arch
<br/><br/>

# Inside installed Arch

## Configure [internet](https://wiki.archlinux.org/title/Iwd) access
```
$ timedatectl
$ systemctl enable --now NetworkManager systemd-networkd systemd-resolved systemd-timesyncd

$ cat << EOF >> /etc/NetworkManager/conf.d/wifi_backend.conf
[device]
wifi.backend=iwd
EOF

$ systemctl restart NetworkManager
$ iwctl device list # check if powered on
$ iwctl station wlan0 scan
$ iwctl station wlan0 get-networks
$ iwctl station wlan0 connect SSID

$ cat << EOF >> /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF
```

### Configure systemd-resolved
```
$ ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
$ sed -i 's/#DNS=.*/DNS=100.64.0.1/' /etc/systemd/resolved.conf
$ sed -i 's/#FallbackDNS=.*/FallbackDNS=1.1.1.1/' /etc/systemd/resolved.conf
$ sed -i 's/#DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf
```

### Configure reflector for mirror management of pacman
```
$ pacman -Sy reflector
$ nano /etc/xdg/reflector/reflector.conf 
$ systemctl enable --now reflector.timer
```

## User management
```
$ useradd -m matt -G wheel
$ passwd matt
```

## A lot of packages to install
```
$ pacman -Sy htop pkgfile mlocate rsync tmux mosh usbutils wget git curl devtools mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau bash-completion fzf
$ pkgfile --update
```

## Install paru
```
$ pacman -S --needed git base-devel
$ git clone https://aur.archlinux.org/paru-git.git
$ cd paru-git
$ makepkg -si

$ sed -i 's/#Color/Color/' /etc/pacman.conf
$ sed -i 's/#IgnorePkg.*/IgnorePkg   = linux-xanmod-anbox linux-xanmod-anbox-headers/' /etc/pacman.conf

$ cat << EOF >> /etc/paru.conf
CombinedUpgrade
BatchInstall
BottomUp
NoWarn = plymouth-theme-arch-elegant
EOF
```

## su matt

## Audio
### ALSA
```
$ yay -Sy alsa-utils alsa-firmware sof-firmware alsa-ucm-conf

#unmute speakers
$ amixer sset Master unmute
```

### Pipewire
```
$ yay -Sy pipewire-audio pipewire-alsa pipewire-pulse
$ yay -R pulseaudio-alsa
$ sudo systemctl stop pulseaudio.service
$ systemctl --user enable --now pipewire-pulse.service
```

## Fingerprint Sensor Hack
```
$ yay -Sy python pam-fprint-grosshack
$ sudo systemctl enable --now fprintd
$ fprintd-enroll
```

### Use the reader
add this to the top of every file in /etc/pam.d/ that you want ie. polkit-1, sudo uwu
```
auth            sufficient      pam_fprintd_grosshack.so
auth            sufficient      pam_unix.so try_first_pass nullok
```
OR (for gtklock and check for sddm)
```
auth      sufficient pam_fprintd.so
```

## Plymouth and Silent Boot
By following the wiki pages on [watchdogs](https://wiki.archlinux.org/title/Improving_performance#Watchdogs), [silent booting](https://wiki.archlinux.org/title/Silent_boot#top-page) and [Plymouth](https://wiki.archlinux.org/title/Plymouth), I edited my grub config and mkinitcpio, installed and setup Plymouth, to get a satisfying booting experience
```
$ yay -Sy plymouth-git
```
/etc/mkinitcpio.conf
```
$ sudo sed -i 's/MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
$ sudo sed -i 's/#COMPRESSION="lz4"/COMPRESSION="lz4"/' /etc/mkinitcpio.conf
$ sudo sed -i 's/HOOKS=(.* /HOOKS=(base udev plymouth encrypt autodetect modconf kms keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf
COMPRESSION="lz4"
```
/etc/default/grub
```
sudo sed -i 's/quiet loglevel 3/quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 splash nowatchdog psi=1/' /etc/default/grub
```
Mute watchdog
```
$ echo blacklist sp5100_tco | sudo tee /etc/modprobe.d/disable-sp5100-watchdog.conf
```
Apply changes [Theme](https://github.com/murkl/plymouth-theme-arch-elegant)
```
$ git clone https://github.com/murkl/plymouth-theme-arch-elegant.git
$ cd plymouth-theme-arch-elegant/aur
$ makepkg -si
$ sudo plymouth-set-default-theme -R arch-elegant
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
$ sudo sed -i 's/echo/#ech~o/g' /boot/grub/grub.cfg
```

## Here are some random changes and tweaks

### Firefox touchscreen [tweak](https://wiki.archlinux.org/title/Firefox/Tweaks#Enable_touchscreen_gestures)
```
$ echo MOZ_USE_XINPUT2 DEFAULT=1 | sudo tee -a /etc/security/pam_env.conf
```
then logout

### More Packages that are most likely needed
```
run toinstall.sh script
$ sudo reboot
```

### Flatpak
```
$ flatpak install com.github.iwalton3.jellyfin-media-player com.github.tchx84.Flatseal xournalpp stemlink
$ sudo flatpak override --filesystem=xdg-config/gtk-3.0
``` 

## Finally, install dotfiles
```
$ mkdir ~/git && cd ~/git
$ git clone git@git.nelim.org:matt1432/dotfiles.git
$ cd dotfiles
$ bash getenv.sh
$ sudo bash setup.sh
$ sudo bash fzf.sh /usr/share/fzf
```
