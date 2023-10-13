{ pkgs, ... }:

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

      # give permanent path to touchpad
      SUBSYSTEMS=="input", ATTRS{id/product}=="01e0", ATTRS{id/vendor}=="27c6", ATTRS{name}=="GXTP5140:00 27C6:01E0 Touchpad", SYMLINK += "touchpad"
    '';

    fwupd.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
      ];
    };

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

  zramSwap.enable = true;
}
