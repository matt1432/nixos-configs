#!/bin/sh
PART="$1"
KEY="$2"

loadkeys ca

cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p$PART
cryptsetup open /dev/nvme0n1p$PART root
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot

mount --mkdir /dev/sda$KEY usb
mv /etc/pacman.conf{,.bak}
mv ./pacman.conf /etc
pacman -Syu

pacstrap -K /mnt base linux-firmware linux amd-ucode patch dkms kmod rtw89-dkms-git btrfs-progs grub os-prober ntfs-3g efibootmgr efivar iwd nano sudo texinfo man-db man-pages

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt