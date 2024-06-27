{
  config,
  modulesPath,
  self,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.nvidia
  ];

  nvidia = {
    enable = true;
    enableCUDA = true;
  };

  boot = {
    kernelModules = ["kvm-intel"];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
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

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
