{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 2;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        extraConfig = ''
          set timeout_style=hidden
        '';
        # Because it still draws that image otherwise
        splashImage = null;
      };
    };

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "cryptdevice=UUID=ab82b477-2477-453f-b95f-28e5553ad10d:root"
      "root=/dev/mapper/root"
    ];

    plymouth = {
      enable = true;
      themePackages = [ pkgs.dracula-plymouth ];
      theme = "dracula";
    };

    # https://github.com/NixOS/nixpkgs/issues/254807#issuecomment-1722351771
    swraid.enable = false;
  };
}
