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

    kernelParams = ["amd_pstate=active"];
    kernelModules = ["kvm-amd"];

    # Zenpower for ryzen cpu monitoring
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
      zenpower
    ];
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
      timeout = 2;

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
  environment.systemPackages = with pkgs; [
    qemu
    virtiofsd
  ];

  nvidia = {
    enable = true;
    enableNvidiaSettings = true;
    enableWayland = true;
    enableCUDA = true;
  };
}
