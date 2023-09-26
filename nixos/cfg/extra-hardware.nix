{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # enable brightness control for swayosd
  programs.light.enable = true;

  services = {

    udev.extraRules = ''
    # give permanent path to keyboard XF86* binds
    SUBSYSTEMS=="input", ATTRS{id/product}=="0006", ATTRS{id/vendor}=="0000", SYMLINK += "video-bus"
  '';

    fwupd.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = with pkgs; [
      hplip
    ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    upower.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    sensor.iio.enable = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    uinput.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
  };
}
