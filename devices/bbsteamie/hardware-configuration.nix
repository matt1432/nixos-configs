{
  config,
  jovian,
  lib,
  modulesPath,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    jovian.nixosModules.default
  ];

  jovian = {
    steamos.useSteamOSConfig = true;

    devices.steamdeck = {
      enable = true;
      enableGyroDsuService = true;
    };
    hardware.has.amd.gpu = true;
  };

  boot = {
    kernelModules = ["kvm-amd"];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "sdhci_pci"];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
    };
  };

  virtualisation.waydroid.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/run/media/mariah/SDCARD" = {
      device = "/dev/disk/by-label/SDCARD";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
