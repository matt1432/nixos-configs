{
  config,
  modulesPath,
  pkgs,
  purePkgs ? pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      # Disable watchdog
      "nowatchdog"
      "modprobe.blacklist=sp5100_tco"

      # Recommend AMD params
      "amd_pstate=active"

      # Remove these if I use plymouth module
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    kernelModules = ["kvm-amd"];

    # Zenpower for ryzen cpu monitoring
    extraModulePackages = builtins.attrValues {
      inherit
        (config.boot.kernelPackages)
        v4l2loopback
        zenpower
        ;
    };
    blacklistedKernelModules = ["k10temp"];

    supportedFilesystems = ["ntfs"];

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    };

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;

      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 30;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
    };

    # sudo btrfs subvolume create /@swap
    "/swap" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      # Idk why this is the subvol
      options = ["subvol=@/@swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

    "/run/media/matt/Games" = {
      device = "/dev/disk/by-uuid/da62f4ee-d4a6-4fdd-ab12-9c5e131c6f30";
      fsType = "ext4";
    };

    "/run/media/matt/HDD-3TB" = {
      device = "/dev/disk/by-uuid/F8626F57626F19A0";
      fsType = "ntfs";
      options = ["defaults" "noauto" "nofail" "noatime" "nodev" "exec" "umask=000" "uid=1000" "gid=1000" "x-systemd.automount"];
    };

    "/run/media/matt/HDD" = {
      device = "/dev/disk/by-uuid/5A10119710117B69";
      fsType = "ntfs";
      options = ["defaults" "noauto" "nofail" "noatime" "nodev" "exec" "umask=000" "uid=1000" "gid=1000" "x-systemd.automount"];
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
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  environment.systemPackages = builtins.attrValues {
    inherit
      (purePkgs)
      qemu
      virtiofsd
      ;
  };

  # FIXME: cuda enabled onnxruntime makes firefox not compile
  nixpkgs.overlays = [
    (final: prev: {
      firefox-devedition-unwrapped = prev.firefox-devedition-unwrapped.override {
        inherit (purePkgs) onnxruntime;
      };
    })
  ];

  nvidia = {
    enable = true;
    enableNvidiaSettings = true;
    enableWayland = true;
    enableCUDA = true;
  };
}
