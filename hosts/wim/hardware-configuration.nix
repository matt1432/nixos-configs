{ config, modulesPath, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      luks.devices."root".device = "/dev/disk/by-uuid/ab82b477-2477-453f-b95f-28e5553ad10d";
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6ae4d722-dacf-485a-8d29-b276f540dc91";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;
  hardware = {
    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

    sensor.iio.enable = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    uinput.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
  };

  # enable brightness control for swayosd
  programs.light.enable = true;

  services.udev.extraRules = ''
    # give permanent path to keyboard XF86* binds
    SUBSYSTEMS=="input", ATTRS{id/product}=="0006", ATTRS{id/vendor}=="0000", SYMLINK += "video-bus"

    # give permanent path to touchpad
    SUBSYSTEMS=="input", ATTRS{id/product}=="01e0", ATTRS{id/vendor}=="27c6", ATTRS{name}=="GXTP5140:00 27C6:01E0 Touchpad", SYMLINK += "touchpad"
  '';
}
