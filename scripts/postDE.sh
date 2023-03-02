#!/bin/sh
yay -Sy python pam-fprint-grosshack
cd /tmp
git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
cd goodix-fp-dump
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
sudo python3 run_55b4.py

yay -Sy libfprint-goodixtls-55x4 fprintd
sudo systemctl enable --now fprintd
fprintd-enroll

yay -Sy plymouth-git gdm-plymouth plymouth-theme-arch-charge-gdm-spinner

sudo sed -i 's/(base udev /(base udev plymouth plymouth-encrypt /' /etc/mkinitcpio.conf
sudo sed -i 's/ encrypt//' /etc/mkinitcpio.conf
sudo sed -i 's/MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf

sudo sed -i 's/quiet loglevel 3/quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3 splash vt.global_cursor_default=0 nowatchdog/' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT="1"/' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE="hidden"/' /etc/default/grub
sudo sed -i 's/GRUB_GFXMODE=.*/GRUB_GFXMODE="1920x1200x32"/' /etc/default/grub
sudo sed -i 's/GRUB_DISABLE_RECOVERY=.*/#GRUB_DISABLE_RECOVERY=true/' /etc/default/grub
sudo sed -i 's/#GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER="false"/' /etc/default/grub
echo blacklist sp5100_tco | sudo tee /etc/modprobe.d/disable-sp5100-watchdog.conf

sudo plymouth-set-default-theme -R arch-charge-gdm-spinner
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i 's/echo/#ech~o/g' /boot/grub/grub.cfg

echo MOZ_USE_XINPUT2 DEFAULT=1 | sudo tee -a /etc/security/pam_env.conf