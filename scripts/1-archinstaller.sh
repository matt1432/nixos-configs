#!/bin/sh
PART="$1"
KEY="$2"

loadkeys ca

fdisk /dev/nvme0n1p$PART
cryptsetup -y -v luksFormat --type luks1 /dev/nvme0n1p$PART
cryptsetup open /dev/nvme0n1p$PART root
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot

pacman -Syu

pacstrap -K /mnt base linux-firmware linux amd-ucode patch dkms kmod btrfs-progs grub os-prober ntfs-3g efibootmgr efivar iwd nano sudo texinfo man-db man-pages

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt