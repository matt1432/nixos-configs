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
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
hwclock --systohc
echo matt-laptop > /etc/hostname
passwd

nano /etc/locale.gen
locale-gen
echo LANG=en_CA.UTF-8 > /etc/locale.conf
echo KEYMAP=ca > /etc/vconsole.conf

nano /etc/mkinitcpio.conf
mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch

CRYPT="cryptdevice=$(blkid | sed -n 's/.*nvme0n1p'$PART': \(.*\) TYPE.*/\1/p'):root"
sed 's#GRUB_CMDLINE_LINUX_DEFAULT.*#GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel 3 '$CRYPT' root=/dev/mapper/root"#' /etc/default/grub