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
```
# pacstrap -K /mnt base linux-firmware linux amd-ucode patch dkms kmod rtw89-dkms-git btrfs-progs grub os-prober ntfs-3g efibootmgr efivar iwd nano sudo texinfo man-db man-pages
```

## misc commands
```
# genfstab -U /mnt >> /mnt/etc/fstab
# arch-chroot /mnt
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
## Edit /mnt/etc/mkinitcpio.conf for LUKS
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

### Edit /mnt/etc/default/grub for LUKS
```
cryptdevice=UUID=??????:root root=/dev/mapper/root
```
make sure the UUID is the actual partition inside the LUKS container and run ```grub-mkconfig -o /boot/grub/grub.cfg```

we can now reboot to the installed Arch
<br/><br/>

# Inside installed Arch

## Configure [internet](https://wiki.archlinux.org/title/Iwd) access
```
# systemctl enable --now iwd systemd-networkd systemd-resolved
# iwctl device list # check if powered on
# iwctl station wlan0 scan
# iwctl station wlan0 get-networks
# iwctl station wlan0 connect SSID
# cat << EOF >> /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF
```

## User management
```
# useradd -m matt -G wheel
# passwd matt
```

yay
htop 3.2.2-1
iwgtk 0.9-1
pkgfile 21-2
plocate 1.1.18-1
rsync 3.2.7-3
tailscale 1.36.1-1
tmux 3.3_a-3
usbutils 015-2
wget 1.21.3-1
git 2.39.1-1
curl 7.87.0-3
devtools 20230105-1

