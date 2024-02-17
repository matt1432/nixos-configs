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
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    blacklistedKernelModules = ["k10temp"];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

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

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
