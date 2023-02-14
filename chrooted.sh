#!/bin/sh
PART="$1"

ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
hwclock --systohc
echo matt-laptop > /etc/hostname
passwd

mv /etc/locale.gen{,.bak}
mv ./locale.gen /etc
locale-gen
echo LANG=en_CA.UTF-8 > /etc/locale.conf
echo KEYMAP=ca > /etc/vconsole.conf

nano /etc/mkinitcpio.conf # TODO SED
mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch

CRYPT="cryptdevice=$(blkid | sed -n 's/.*nvme0n1p'$PART': \(.*\) TYPE.*/\1/p'):root"
sed -i 's#GRUB_CMDLINE_LINUX_DEFAULT.*#GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel 3 '$CRYPT' root=/dev/mapper/root"#' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

echo REBOOT