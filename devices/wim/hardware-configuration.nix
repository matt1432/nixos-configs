{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd" "acpi_call"];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
      acpi_call
    ];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];

      luks.devices."root" = {
        device = "/dev/disk/by-uuid/ab82b477-2477-453f-b95f-28e5553ad10d";
      };
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

    # https://github.com/NixOS/nixpkgs/issues/254807#issuecomment-1722351771
    swraid.enable = false;
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
  environment.systemPackages = with pkgs; [
    qemu
  ];

  # enable brightness control
  programs.light.enable = true;

  services = {
    tlp.enable = true;

    udev.extraRules =
      /*
      udev
      */
      ''
        # give permanent path to keyboard XF86* binds
        SUBSYSTEMS=="input", ATTRS{id/product}=="0006", ATTRS{id/vendor}=="0000", SYMLINK += "video-bus"
      '';
  };
}
