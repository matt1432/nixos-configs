{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "amd_pstate=active"
    ];
    kernelModules = ["amdgpu" "kvm-amd" "acpi_call"];

    extraModulePackages = builtins.attrValues {
      inherit
        (config.boot.kernelPackages)
        acpi_call
        zenpower
        ;
    };
    blacklistedKernelModules = ["k10temp"];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];

      luks.devices."root" = {
        device = "/dev/disk/by-uuid/ab82b477-2477-453f-b95f-28e5553ad10d";
      };
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 30;
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

    # sudo btrfs subvolume create /@swap
    "/swap" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = ["subvol=@swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  zramSwap.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

    uinput.enable = true;
    sensor.iio.enable = true;

    amdgpu.initrd.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host = {
      enable = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
    waydroid.enable = true;
  };
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      qemu
      powertop
      virt-v2v
      ;
  };

  # enable brightness control
  programs.light.enable = true;

  services = {
    xserver.videoDrivers = ["modesetting"];

    # https://www.reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
    pipewire.wireplumber.extraConfig."10-disable-camera" = {
      "wireplumber.profiles" = {
        main = {
          "monitor.libcamera" = "disabled";
        };
      };
    };

    tlp = {
      enable = true;
      settings = {
        NMI_WATCHDOG = 0;

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
    power-profiles-daemon.enable = false;

    udev.extraRules =
      # udev
      ''
        # give permanent path to keyboard XF86* binds
        SUBSYSTEMS=="input", ATTRS{id/product}=="0006", ATTRS{id/vendor}=="0000", SYMLINK += "video-bus"
      '';
  };
}
